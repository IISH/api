package org.socialhistory.solr.transformers;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.solr.handler.dataimport.Context;
import org.apache.solr.handler.dataimport.Transformer;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.*;


public class FSTransformer extends Transformer {

    public FSTransformer() {
        super();
    }

    @Override
    public Object transformRow(Map<String, Object> row, Context context) {
        final Map<String, Object> params = context.getRequestParameters();
        final String debugTraceFolder = (String) params.get("debugTraceFolder");
        final String unformatted_resource_normalize = (String) params.get("resource");
        final String fileAbsolutePath = (String) row.get("fileAbsolutePath");

        if (Boolean.parseBoolean(System.getProperty("debug"))) System.out.println(fileAbsolutePath);

        byte[] ba_schema;
        try {
            ba_schema = DoTransform.PerformTransform(context, (String) params.get("normalize"), row);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        DebugTrace.writeDebugFolder(debugTraceFolder, "normalize", ba_schema);

        byte[] ba_solr;
        try {
            ba_solr = DoTransform.PerformTransform(context, (String) params.get("importer"), row, ba_schema);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        DebugTrace.writeDebugFolder(debugTraceFolder, "importer", ba_solr);

        Document doc = GetDOMDocument(new ByteArrayInputStream(ba_solr));
        if (doc == null)
            return null;

        NodeList nodelist = doc.getElementsByTagName("field");
        Map<String, List> map = new HashMap();
        for (int i = 0; i < nodelist.getLength(); i++) {

            Node node = nodelist.item(i);
            NamedNodeMap attributes = node.getAttributes();
            String field_value = node.getTextContent();
            Node attribute_field_name = attributes.getNamedItem("name");
            if (field_value != null && field_value.length() != 0 && attribute_field_name != null) {

                String key = attribute_field_name.getNodeValue();
                List list;
                if (map.containsKey(key)) {
                    list = map.get(key);
                    if (!list.contains(field_value))
                        list.add(field_value);
                } else {
                    list = new ArrayList();
                    list.add(field_value);
                    map.put(key, list);
                }
            }
        }

        row.clear();
        for (Object o : map.entrySet()) {

            Map.Entry<String, ArrayList> entry = (Map.Entry) o;
            String key = entry.getKey();
            List list = entry.getValue();
            if (list.size() == 1)
                row.put(key, list.get(0)); // String
            else
                row.put(key, list); // Becomes an array, but without a name attribute.
        }

        String date_modified = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(new Date(new File(fileAbsolutePath).lastModified()));
        row.put("iisg_datestamp", date_modified);

        try {
            row.put("resource", new String(ba_schema, "utf-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        File file = new File(context.getSolrCore().getSolrConfig().getResourceLoader().getConfigDir() + unformatted_resource_normalize);
        if (file.exists()) {
            byte[] unf_res = new byte[0];
            try {
                unf_res = DoTransform.PerformTransform(fileAbsolutePath, context, unformatted_resource_normalize);
                row.put("original", new String(unf_res, "utf-8"));
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (TransformerConfigurationException e) {
                e.printStackTrace();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            DebugTrace.writeDebugFolder(debugTraceFolder, "original", unf_res);
        }
        return row;
    }

    /*private byte[] getFromFile(String fileAbsolutePath) throws IOException {

        File file = new File(fileAbsolutePath);
        InputStream is = new FileInputStream(file);
        final int length = (int) file.length();
        byte[] array = new byte[length];
        for (int i = 0; i < length; i++) {
            array[i] = (byte) is.read();
        }
        return array;
    }*/

    private Document GetDOMDocument(ByteArrayInputStream is) {

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db;

        try {
            db = dbf.newDocumentBuilder();
        } catch (ParserConfigurationException e) {
            log.error(e);
            return null;
        }

        Document doc;
        try {
            doc = db.parse(is);
        } catch (SAXException e) {
            log.error(e);
            return null;
        } catch (IOException e) {
            log.error(e);
            return null;
        }

        doc.getDocumentElement().normalize();

        db.setErrorHandler(null); // setting implementation default
        db.setEntityResolver(null); // setting implementation default

        return doc;
    }


    private final Log log = LogFactory.getLog(this.getClass());
}
