package org.socialhistory.solr.transformers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Utility class for debugging XML output.
 * The COUNT is used to give filesnames unique names.
 */
public class DebugTrace {

    private static int count = 0;

    public static void writeDebugFolder(String debugTraceFolder, String phase, byte[] ba_schema) {

        if (debugTraceFolder != null && !debugTraceFolder.isEmpty()) {
            if (Boolean.parseBoolean(System.getProperty("debug"))) {

                File folder = new File(debugTraceFolder);
                if (!folder.exists())
                    folder.mkdirs();

                String file = debugTraceFolder + File.separator + String.valueOf(count++) + "." + phase + ".xml";
                try {
                    FileOutputStream fos = new FileOutputStream(file);
                    fos.write(ba_schema);
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

}
