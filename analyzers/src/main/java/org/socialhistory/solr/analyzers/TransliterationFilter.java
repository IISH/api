package org.socialhistory.solr.analyzers;

import org.apache.lucene.analysis.TokenFilter;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.TermAttribute;

import java.io.IOException;
import java.util.HashMap;

/**
 * Generic transliteration class. It substitutes any character with a ASCII-127 charset.
 *
 */
public class TransliterationFilter extends TokenFilter {

    private HashMap<Character, String> translist;
    private TermAttribute termAtt;

    public TransliterationFilter(HashMap<Character, String> translist, TokenStream tokenStream) {
        super(tokenStream);
        this.translist = translist;
        termAtt = (TermAttribute) addAttribute(TermAttribute.class);
    }

    public final boolean incrementToken() throws IOException {
        if (input.incrementToken()) {

            final char[] buffer = termAtt.termBuffer();
            final int length = termAtt.termLength();
            StringBuilder sb = new StringBuilder(length);
            for (int i = 0; i < length; i++)
            {
                String newstr = translist.get(buffer[i]);
                if ( newstr == null )
                    sb.append(buffer[i]);
                else
                   sb.append(newstr);
            }
            char[] chars = sb.toString().toCharArray();
            termAtt.setTermBuffer(chars, 0, chars.length);

            return true;
        } else
            return false;
    }
}
