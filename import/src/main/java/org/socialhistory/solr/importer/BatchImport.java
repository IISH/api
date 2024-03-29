package org.socialhistory.solr.importer;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.ByteArrayRequestEntity;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.RequestEntity;
import org.apache.log4j.Logger;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.*;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;


/**
 * Mass import of files into the index
 * <p/>
 * args:
 * 0=folder containing files with a record; or catalog with records;
 * 1=SOLR update url with core, like http://localhost:8080/solr/all/update
 * 2=comma separated xslt stylesheets: first must be an identity template
 * 3=xslt parameters
 */
public class BatchImport {

    private File urlOrigin;
    private final String urlResource;
    private final List<Transformer> tChain;
    private int counter = 0;
    final HttpClient httpclient = new HttpClient();
    private final boolean debug;

    final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

    public BatchImport(String urlResource, String _xslts, String _parameters) throws TransformerConfigurationException {

        this.debug = Boolean.parseBoolean(System.getProperty("debug", "false"));
        this.urlResource = urlResource;
        final String[] parameters = _parameters.split("[,;]");
        final String[] xslts = _xslts.split("[,;]");
        tChain = new ArrayList<>(xslts.length + 1);
        final TransformerFactory tf = TransformerFactory.newInstance();
        tChain.add(tf.newTransformer());

        for (String xslt : xslts) {
            File file = new File(xslt);
            Source source = new StreamSource(file);
            final Transformer t = tf.newTransformer(source);
            t.setParameter("sheet", file.getName());
            for (String parameter : parameters) {
                String[] split = parameter.split(":");
                t.setParameter(split[0], split[1]);
            }
            tChain.add(t);
            if (debug) log.info("xslt stylesheet: " + file.getAbsolutePath());
        }
    }

    public void process(File f) throws FileNotFoundException, XMLStreamException {

        if (f.isFile()) { // everything comes from one catalog file
            final XMLInputFactory xif = XMLInputFactory.newInstance();
            final FileInputStream inputStream = new FileInputStream(f);
            final XMLStreamReader xsr = xif.createXMLStreamReader(inputStream, "utf-8");

            while (xsr.hasNext()) {
                if (xsr.getEventType() == XMLStreamReader.START_ELEMENT) {
                    String elementName = xsr.getLocalName();
                    if ("record".equals(elementName)) {
                        try {
                            final byte[] record = process(identity(xsr), null);
                            sendSolrDocument(record);
                        } catch (IOException | TransformerException e) {
                            log.warn(e);
                        }
                    } else {
                        xsr.next();
                    }
                } else {
                    xsr.next();
                }
            }
        } else { // everything comes from files within a directory
            final File[] files = f.listFiles();
            if (files == null) throw new FileNotFoundException("Folder has no files: " + f.getAbsolutePath());
            for (File file : files) {
                try {
                    byte[] origin = findOrigin(file);
                    if (urlOrigin != null && origin.length == 0) {
                        log.warn("Negeer: geen origineel document gevonden bij " + file.getAbsolutePath());
                    } else {
                        origin = convertRecord(tChain.get(1), origin); // assumption: the first is normalization of prefix\
                        final byte[] record = process(Files.readAllBytes(file.toPath()), origin, datestamp(file.lastModified()));
                        sendSolrDocument(record);
                    }
                } catch (IOException | TransformerException e) {
                    log.warn(file.getAbsolutePath());
                    log.warn(e);
                }
            }
        }
    }

    // Een origin file is simpelweg een file parallel naast de aangeboden file.
    // Als we die vinden in een ander pad met dezelfde filenaam, dan gebruiken we die.
    //
    // Voorbeeld:
    // file: /a/b/c/d/e/f/12345.xml
    // parent: /a/b/c/d/e/f
    // zoek en vind: /a/b/c/d/e/h/12345.xml
    private byte[] findOrigin(final File file) throws IOException {

        if (urlOrigin == null) { // cache origin root
            final File parent = file.getParentFile();// in het voorbeeld is dit /a/b/c/d/e/f
            final File root = parent.getParentFile();// in het voorbeeld is dit /a/b/c/d/e
            for (File folder : Objects.requireNonNull(root.listFiles(pathname -> {
                return pathname.isDirectory()
                        && !pathname.getAbsolutePath().equalsIgnoreCase(parent.getAbsolutePath()); // we willen de andere folders vinden
            }))) {
                final File candidate = new File(folder, file.getName());
                if (candidate.exists() && candidate.isFile()) {
                    urlOrigin = new File(folder.getAbsolutePath());
                    break;
                }
            }
            if (urlOrigin == null) urlOrigin = new File("dummy");
        }

        if (urlOrigin.exists()) {
            final File candidate = new File(urlOrigin, file.getName());
            return (candidate.exists()) ? Files.readAllBytes(candidate.toPath()) : new byte[]{};
        }

        return new byte[]{};
    }

    private byte[] process(byte[] record, byte[] origin) throws IOException, TransformerException {
        return process(record, origin, datestamp( new Date().getTime()));
    }

    private byte[] process(byte[] record, byte[] origin, String datestamp) throws IOException, TransformerException {
        String resource = null;
        for (int i = 1; i < tChain.size(); i++) { // from second sheet. Skip the inbuilt identity template
            tChain.get(i).setParameter("datestamp", datestamp);
            if (i == tChain.size() - 1) { // last sheet, add resources and original
                tChain.get(i).setParameter("resource", resource);
                if (origin != null && origin.length != 0) {
                    final String doc = new String(origin, StandardCharsets.UTF_8);
                    tChain.get(i).setParameter("original", doc);
                }
            }
            record = convertRecord(tChain.get(i), record);
            if (i == tChain.size() - 3) { // before the penultimate sheet
                resource = new String(record, StandardCharsets.UTF_8);
            }
        }
        return record;
    }

    private void sendSolrDocument(byte[] record) throws IOException {

        final ByteArrayOutputStream baos = new ByteArrayOutputStream(record.length + 11);
        baos.write(record);

        if (debug) {
            final String doc = new String(baos.toByteArray(), StandardCharsets.UTF_8);
            System.out.println(doc);
        }

        final PostMethod post = new PostMethod(urlResource);
        final RequestEntity entity = new ByteArrayRequestEntity(baos.toByteArray(), "text/xml; charset=utf-8");
        post.setRequestEntity(entity);
        log.info("Sending " + ++counter);
        try {
            httpclient.executeMethod(post);
        } catch (Exception e) {
            log.warn(e);
        } finally {
            post.releaseConnection();
        }

    }

    private byte[] convertRecord(Transformer transformer, byte[] record) throws TransformerException {

        final StreamSource source = new StreamSource(new ByteArrayInputStream(record));
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(source, new StreamResult(baos));
        transformer.reset();
        final byte[] bytes = baos.toByteArray();
        if (debug) {
            final String s = new String(bytes, StandardCharsets.UTF_8);
            log.info("xslt result: " + s);
        }
        return bytes;
    }

    private byte[] identity(XMLStreamReader xsr) throws TransformerException {
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        tChain.get(0).transform(new StAXSource(xsr), new StreamResult(baos));
        return baos.toByteArray();
    }

    private String datestamp(long time) {
        final Date date = new Date(time);
        return simpleDateFormat.format(date);
    }

    public static void main(String[] args) throws Exception {

        if (args.length != 4) {
            System.err.println("Expect: 'file' to resource or folder with resource docuemnts; 'url' to solr; 'xslt' list; 'parameters'");
            System.exit(1);
        }

        File file = new File(args[0]);
        if (!file.exists()) {
            System.err.println("File or folder not found: " + args[0]);
            System.exit(1);
        }

        final String url = args[1];
        final String xslt = args[2]; // het eerste sheet is een identity sheet.
        final String parameters = args[3];

        final BatchImport importer = new BatchImport(url, xslt, parameters);
        importer.process(file);
    }

    private final Logger log = Logger.getLogger(getClass().getName());
}