package org.socialhistory.solr.importer;

import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.store.FSDirectory;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.util.Arrays;
import java.util.List;

/**
 * Exports the Lucene document.resource fields as XML.
 */
public class ExportIndex {

    final IndexReader reader;
    final Transformer transformer;
    int count = 0;


    public ExportIndex(String index) throws IOException, TransformerConfigurationException {
        final FSDirectory directory = FSDirectory.open(new File(index));
        reader = IndexReader.open(directory);


        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        final InputStream resourceAsStream = this.getClass().getResourceAsStream("/marc.xsl");
        transformer = transformerFactory.newTransformer(new StreamSource(resourceAsStream));
    }

    public void export(String collectionName) throws IOException, TransformerException {

        String file = collectionName + ".xml";
        final FileOutputStream fileOutputStream = new FileOutputStream(file);
        fileOutputStream.write("<marc:catalog xmlns:marc=\"http://www.loc.gov/MARC21/slim\">".getBytes());

        for (int i = 0; i < reader.numDocs(); i++) {
            final Document document = reader.document(i);
            List<String> iisg_collectionNames = Arrays.asList(document.getValues("iisg_collectionName"));
            if (iisg_collectionNames.contains(collectionName)) {
                transformer.reset();
                transformer.setOutputProperty("omit-xml-declaration", "yes");
                final byte[] bytes = document.get("resource").getBytes("UTF8");
                if (bytes != null || bytes.length != 0) {
                    count++;
                    transformer.transform(new StreamSource(new ByteArrayInputStream(bytes)), new StreamResult(fileOutputStream));
                }
            }
        }

        fileOutputStream.write("</marc:catalog>".getBytes());
        fileOutputStream.close();
        reader.close();

        System.out.println("Count: " + count);
    }


    /**
     * main
     * <p/>
     * args[0] = index path
     * args[1] = collectionName
     *
     * @param args
     */
    public static void main(String[] args) throws IOException, TransformerException {
        ExportIndex dirtyExporter = new ExportIndex(args[0]);
        dirtyExporter.export(args[1]);
    }

}
