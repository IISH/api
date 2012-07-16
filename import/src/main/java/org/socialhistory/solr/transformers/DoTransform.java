package org.socialhistory.solr.transformers;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.solr.core.SolrConfig;
import org.apache.solr.handler.dataimport.Context;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * Loads, caches and parses the stylesheets that are required for the normalization and import to the Solr Add document
 * schema.
 */
class DoTransform {
    public static byte[] PerformTransform(Context context, String xslt, Map<String, Object> row, byte[] ba) throws MalformedURLException, TransformerConfigurationException {

        ByteArrayInputStream bais = new ByteArrayInputStream(ba);
        StreamSource source = new StreamSource(bais);
        return PerFormTransForm(context, xslt, source, row);

    }

    public static byte[] PerformTransform(String file, Context context, String xslt, Map<String, Object> row) throws MalformedURLException, TransformerConfigurationException {

        StringReader sr = new StringReader("<dataroot/>");
        StreamSource source = new StreamSource(sr);
        return PerFormTransForm(context, xslt, source, row);
    }

    public static byte[] PerformTransform(StreamSource source, Context context, String xslt, Map<String, Object> row) throws MalformedURLException, TransformerConfigurationException {
        return PerFormTransForm(context, xslt, source, row);
    }

    public static byte[] PerformTransform(Context context, String xslt, Map<String, Object> row) throws MalformedURLException, TransformerConfigurationException {

        String fileAbsolutePath = (String) row.get("fileAbsolutePath");
        StreamSource source = new StreamSource(fileAbsolutePath);
        return PerFormTransForm(context, xslt, source, row);
    }

    private static byte[] PerFormTransForm(Context context, String xslt, StreamSource source, Map<String, Object> row) throws MalformedURLException, TransformerConfigurationException {

        javax.xml.transform.Transformer transformer = GetTransform(context, xslt);
        insertParameters(row, transformer);
        ByteArrayOutputStream writer = new ByteArrayOutputStream();
        StreamResult result = new StreamResult(writer);

        try {
            transformer.transform(source, result);
        } catch (TransformerException e) {
            e.printStackTrace();
        }
        return writer.toByteArray();
    }

    public static byte[] PerformTransform(String fileAbsolutePath, Context context, String xslt) throws MalformedURLException, TransformerConfigurationException {

        StreamSource source = new StreamSource(fileAbsolutePath);
        return PerFormTransForm(context, xslt, source, null);
    }

    /**
     * Instantiate the transformer and add global parameters such as date and collection.
     *
     * @param context
     * @param xslt
     * @return
     * @throws TransformerConfigurationException
     * @throws MalformedURLException
     */
    private static javax.xml.transform.Transformer GetTransform(Context context, String xslt) throws TransformerConfigurationException, MalformedURLException {
        // no need to synchronize access to context, right?
        // Nothing else happens with it at the same time

        javax.xml.transform.Transformer provider = (javax.xml.transform.Transformer) context.getSessionAttribute(xslt, Context.SCOPE_ENTITY);
        if (provider == null) {
            SolrConfig solrConfig = context.getSolrCore().getSolrConfig();
            File file_stylesheet = new File(solrConfig.getResourceLoader().getConfigDir() + xslt);
            Source xslSource = new StreamSource(file_stylesheet);
            xslSource.setSystemId(file_stylesheet.toURI().toURL().toString());

            TransformerFactory tFactory = TransformerFactory.newInstance();
            provider = tFactory.newTransformer(xslSource);

            // Set some system xslt params:
            Date now = new Date();

            String date_modified = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(now);
            String marc_controlfield_005 = new SimpleDateFormat("yyyyMMddHHmmss").format(now);
            String marc_controlfield_008 = new SimpleDateFormat("yyMMdd's'").format(now);

            provider.setParameter("date_modified", date_modified);
            provider.setParameter("marc_controlfield_005", marc_controlfield_005);
            provider.setParameter("marc_controlfield_008", marc_controlfield_008);
            provider.setParameter("collectionName", file_stylesheet.getName().replace(".xsl", ""));

            insertParameters(context.getRequestParameters(), provider);

            context.setSessionAttribute(xslt, provider, Context.SCOPE_ENTITY);
        }

        return provider;
    }

    private static void insertParameters(Map<String, Object> params, Transformer provider) {

        if (params == null)
            return;

        for (Object o : params.keySet()) {

            String key = (String) o;
            Object v = params.get(key);
            if (v != null) {
                String value = String.valueOf(params.get(key));
                provider.setParameter(key, value);
            }
        }
    }
}