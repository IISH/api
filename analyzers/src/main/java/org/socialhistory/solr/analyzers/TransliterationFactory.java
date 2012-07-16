package org.socialhistory.solr.analyzers;

import org.apache.lucene.analysis.TokenStream;
import org.apache.solr.common.ResourceLoader;
import org.apache.solr.util.plugin.ResourceLoaderAware;

import java.io.*;
import java.util.HashMap;
import java.util.List;

/**
 * Factory for the transliteration classes.
 */
public class TransliterationFactory extends org.apache.solr.analysis.BaseTokenFilterFactory implements ResourceLoaderAware {

    private HashMap<Character, String> translist = null;

    @Override
    public TokenStream create(TokenStream tokenStream) {

        if (translist == null)
            return tokenStream;
        return new TransliterationFilter(translist, tokenStream);
    }

    @Override
    public void inform(ResourceLoader loader) {

        String file = args.get("translist");
        if (file == null) {
            return;
        }
        List<String> lines;
        try {
            lines = loader.getLines(file);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }
        read(lines);
    }

    private void read(List<String> lines) {

        this.translist = new HashMap<Character, String>();
        for (String line : lines) {
            String[] split = line.split("\\s|\\t", 2);
            if (split.length == 2) {
                translist.put(split[0].charAt(0), split[1]);
            }
        }
    }
}