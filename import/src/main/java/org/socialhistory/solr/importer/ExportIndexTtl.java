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
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;

/**
 * Exports the Lucene document.resource fields as JSON documents.
 */
public class ExportIndexTtl {

    final IndexReader reader;
    final Transformer transformer;
    int count = 0;


    public ExportIndexTtl(String index) throws IOException, TransformerConfigurationException {
        final FSDirectory directory = FSDirectory.open(new File(index));
        reader = IndexReader.open(directory);


        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        final InputStream resourceAsStream = this.getClass().getResourceAsStream("/marc2ttl.xsl");
        transformer = transformerFactory.newTransformer(new StreamSource(resourceAsStream));
    }

    public void export(String collectionName) throws IOException, TransformerException {

        String file = collectionName + ".json";
        final LinelessFileOutputStream fileOutputStream = new LinelessFileOutputStream(file);

        for (int i = 0; i < reader.numDocs(); i++) {
            final Document document = reader.document(i);
            List<String> iisg_collectionNames = Arrays.asList(document.getValues("iisg_collectionName"));
            if (iisg_collectionNames.contains(collectionName)) {
                transformer.reset();
                transformer.setOutputProperty("omit-xml-declaration", "yes");
                transformer.setOutputProperty("media-type", "text");
                final byte[] bytes = document.get("resource").getBytes("UTF8");
                if (bytes != null || bytes.length != 0) {
                    count++;
                    transformer.transform(new StreamSource(new ByteArrayInputStream(bytes)), new StreamResult(fileOutputStream));
                    fileOutputStream.lineFeed();
                }
            }
        }

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
        ExportIndexTtl dirtyExporter = new ExportIndexTtl(args[0]);
        dirtyExporter.export(args[1]);
    }

}
