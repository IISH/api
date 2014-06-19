package org.socialhistory.solr.importer;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.*;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;


/**
 * Validate
 * <p/>
 * args:
 * 0=catalog to validate
 */
public class Validate {

    private final Transformer identityTemplate;
    private File file;
    private Validator validator;

    public Validate(File file) throws MalformedURLException, SAXException, TransformerConfigurationException {

        this.file = file;

        final SchemaFactory factory =
                SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

        // 2. Compile the schema.
        // Here the schema is loaded from a java.io.File, but you could use
        // a java.net.URL or a javax.xml.transform.Source instead.
        final URL resource = this.getClass().getResource("/MARC21slim.xsd");
        final Schema schema = factory.newSchema(resource);

        // 3. Get a validator from the schema.
        validator = schema.newValidator();

        final TransformerFactory tf = TransformerFactory.newInstance();
        identityTemplate = tf.newTransformer();
    }

    public void process() throws FileNotFoundException, XMLStreamException {

        final XMLInputFactory xif = XMLInputFactory.newInstance();
        FileInputStream inputStream = new FileInputStream(file);
        final XMLStreamReader xsr = xif.createXMLStreamReader(inputStream, "utf-8");

        while (xsr.hasNext()) {

            if (xsr.getEventType() == XMLStreamReader.START_ELEMENT) {
                String elementName = xsr.getLocalName();
                if ("record".equals(elementName)) {
                    try {
                        process(xsr);
                    } catch (Exception e) {
                        log.warn(e);
                    }
                } else {
                    xsr.next();
                }
            } else {
                xsr.next();
            }
        }
    }

    private void process(XMLStreamReader xsr) throws TransformerException {

        final ByteArrayOutputStream baos = new ByteArrayOutputStream();

        // final Result result = new StreamResult(baos);
        final byte[] recordAsBytes = getRecordAsBytes(xsr);
        final Source source = new StreamSource(new ByteArrayInputStream(recordAsBytes));
        try {
            validator.validate(source);
        } catch (SAXException e) {
            report(e.getMessage(), recordAsBytes);
        } catch (IOException e) {
            report(e.getMessage(), recordAsBytes);
        }
        validator.reset();
    }

    private void report(String message, byte[] marc) {

        String text = new String(marc);
        int i = text.indexOf("<marc:controlfield tag=\"001\">")+29;
        int j = text.indexOf("</marc:controlfield>", i);
        if (i != 28) {
            try {
                System.out.write(marc, i, j-i);
                System.out.write('\t');
                System.out.write(message.getBytes());
                System.out.write('\n');
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private byte[] getRecordAsBytes(XMLStreamReader xsr) throws TransformerException {
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        identityTemplate.transform(new StAXSource(xsr), new StreamResult(baos));
        return baos.toByteArray();
    }

    public static void main(String[] args) throws Exception {

        File file = new File(args[0]);
        if (!file.exists() || file.isDirectory()) {
            System.err.println("File not found.");
            System.exit(1);
        }

        Validate importer = new Validate(file);
        importer.process();
    }

    private Logger log = Logger.getLogger(getClass().getName());
}