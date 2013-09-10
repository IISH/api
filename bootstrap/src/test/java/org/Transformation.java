package org;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

public class Transformation {

    /**
     * @param args
     * args[0] = location of stylesheet
     * args[1] = folder of source files
     * args[2] = folder of target files
     * @throws MalformedURLException
     * @throws TransformerException
     */
    public static void main(String[] args) throws MalformedURLException, TransformerException {

        final URL resource = new File( args[0] ).toURL();
        Source s = null;
        try {
            s = new StreamSource(resource.openStream());
        } catch (IOException e) {
            System.err.println(e.getMessage());
            System.exit(-1);
        }

        s.setSystemId(resource.toString());

        final TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = null;
        try {
            transformer = tf.newTransformer(s);
        } catch (TransformerConfigurationException e) {
            System.err.println(e.getMessage());
            System.exit(-1);
        }


        final File[] files = new File(args[1]).listFiles(new FilenameFilter() {
            @Override
            public boolean accept(File file, String s) {
                return s.startsWith("ARCH") | s.startsWith("COLL") ;
            }
        });

        for (File file : files) {
            final File target = new File(args[2], file.getName());
            transformer.transform(new StreamSource(file), new StreamResult(target));
            transformer.reset();
    }


}

}
