/*
 * OAI4Solr exposes your Solr indexes using an OAI2 protocol handler.
 *
 *     Copyright (C) 2012  International Institute of Social History
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.socialhistory.solr.bootstrap;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayOutputStream;
import java.io.File;

public class ToFile {

    public static void main(String[] args) throws TransformerException {

        final TransformerFactory transformerFactory = TransformerFactory.newInstance();
        final Transformer transformer = transformerFactory.newTransformer(new StreamSource("C:\\Users\\lwo\\org.socialhistory.api\\bootstrap\\src\\main\\resources\\ToFile.xsl"));

        final File folder = new File("C:\\mnt\\test");
        final File[] files = folder.listFiles();
        for (File file : files) {
            final File file2 = getFileName(file);
            final StreamSource source = new StreamSource(file);
            final StreamResult result = new StreamResult(file2);
            transformer.transform(source, result);
        }
    }

    private static File getFileName(File file) throws TransformerException {

        final TransformerFactory transformerFactory = TransformerFactory.newInstance();
        final Transformer transformer = transformerFactory.newTransformer(new StreamSource("C:\\Users\\lwo\\org.socialhistory.api\\bootstrap\\src\\main\\resources\\FileName.xsl"));
        final StreamSource source = new StreamSource(file);
        final ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        final StreamResult result = new StreamResult(outputStream);
        transformer.transform(source, result);
        return new File(file.getParent(), outputStream.toString() + ".xml");
    }

}
