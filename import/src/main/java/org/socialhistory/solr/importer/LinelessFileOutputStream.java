package org.socialhistory.solr.importer;

import java.io.*;

public class LinelessFileOutputStream extends FileOutputStream {

    private static int lineFeed = 10;


    @Override
    public void write(int i) throws IOException {
        if (i != lineFeed) {
            super.write(i);
        }
    }

    @Override
    public void write(byte[] bytes) throws IOException {
        rewrite(bytes, 0, bytes.length);
        super.write(bytes);
    }

    @Override
    public void write(byte[] bytes, int start, int length) throws IOException {
        rewrite(bytes, start, length);
        super.write(bytes);
    }

    private void rewrite(byte[] bytes, int start, int length) {
        for (int i = start; i < length; i++) {
            if (bytes[i] == lineFeed)
                bytes[i] = 32;
        }
    }

    public LinelessFileOutputStream(String file) throws FileNotFoundException {
        super(file);
    }

    public void lineFeed() {
        try {
            super.write(lineFeed);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
