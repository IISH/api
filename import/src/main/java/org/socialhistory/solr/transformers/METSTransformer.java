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
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class METSTransformer extends Transformer
{
    private static String Inventaris_nummer = "" ;
    private static String _fileAbsolutePath = null;
    private static String debugTraceFolder;

    // Implementations of this abstract class must provide a public no-args constructor.
    public METSTransformer()
    {
    }

    @Override
    public Object transformRow(Map<String, Object> row, Context context)
    {
        String fileAbsolutePath = (String)row.get("fileAbsolutePath");
        if ( fileAbsolutePath != null )
        {
            _fileAbsolutePath = fileAbsolutePath;
            return row;
        }

        Map<String,Object> params = context.getRequestParameters();
        if ( debugTraceFolder == null )
            debugTraceFolder = (String)params.get("debugTraceFolder");

        String _Inventaris_nummer = (String)row.get("Inventarisnummer_container");
        if ( _Inventaris_nummer.compareTo(Inventaris_nummer) == 0 )
            return null;

        Inventaris_nummer = _Inventaris_nummer;

        byte[] ba_schema ;
        try {
            ba_schema = DoTransform.PerformTransform(_fileAbsolutePath, context, (String)params.get("normalize"), row);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        DebugTrace.writeDebugFolder( debugTraceFolder, "normalize", ba_schema);

        byte[] ba_solr ;
        try {
            ba_solr = DoTransform.PerformTransform(context, (String)params.get("importer"), row, ba_schema);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        DebugTrace.writeDebugFolder( debugTraceFolder, "importer", ba_solr);

        Document doc = GetDOMDocument(new ByteArrayInputStream(ba_solr));
        if ( doc == null )
            return null;

        NodeList nodelist = doc.getElementsByTagName("field") ;
        Map<String,List> map = new HashMap();
        for ( int i = 0 ; i < nodelist.getLength() ; i++ )
        {
            Node node = nodelist.item(i) ;
            NamedNodeMap attributes = node.getAttributes();


            String field_value = node.getTextContent();
            Node attribute_field_name = attributes.getNamedItem("name") ;

            if ( field_value != null && field_value.length() != 0 && attribute_field_name != null)
            {
                String key = attribute_field_name.getNodeValue() ;
                List list;
                if ( map.containsKey(key))
                {
                    list = map.get(key);
                    if ( !list.contains(field_value))
                        list.add(field_value);
                }
                else
                {
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
                row.put(key, list); // Becomes an array.
        }

        try
        {
            String resource = new String(ba_schema, "utf-8") ;
            row.put("resource", resource) ;
        }
        catch (UnsupportedEncodingException e)
        {
            log.warn(e);
        }
        
        return row ;
    }

    private Document GetDOMDocument(ByteArrayInputStream is)
    {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db;

        try {
            db = dbf.newDocumentBuilder();
        } catch (ParserConfigurationException e) {
            log.error(e);
            return null ;
        }

        Document doc;
        try {
            doc = db.parse(is);
        } catch (SAXException e) {
            log.error(e);
            return null ;
        } catch (IOException e) {
            log.error(e);
            return null ;
        }

        doc.getDocumentElement().normalize();

        db.setErrorHandler(null); // setting implementation default
        db.setEntityResolver(null); // setting implementation default

        return doc ;
    }

    private final Log log = LogFactory.getLog(this.getClass());
}