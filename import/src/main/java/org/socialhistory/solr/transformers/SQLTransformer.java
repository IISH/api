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
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;

/**
 * Extracting XML from a database results in nestled XML elements, that do not know when to end the nestling element.
 * For this purpose te "close" attribute is introduce. It indicated the ( sub ) tables should not nestled further
 * child tables and add sibling elements in stead.
 *
 * The attribute eod ends the XML document.
 *
 */
public class SQLTransformer extends Transformer
{
    // Converting from a datasource.
    final private static String SCOPE = "document" ;
    final private static String DOCUMENT_BA = "ba" ;
    final private static String DOCUMENT_XML = "xml" ;
    private String debugTraceFolder;

    // Implementations of this abstract class must provide a public no-args constructor.
    public SQLTransformer()
    {}

    @Override
    public Object transformRow(Map<String, Object> row, Context context)
    {
        Map<String,Object> params = context.getRequestParameters();
        String entity_name = context.getEntityAttribute("name") ;
        if ( debugTraceFolder == null )
            debugTraceFolder = (String)params.get("debugTraceFolder");

        boolean closeElement = getEntityAttribute(context.getEntityAttribute("close"));
        boolean closeDocument = getEntityAttribute(context.getEntityAttribute("eod"));
        boolean ignoreElement = getEntityAttribute(context.getEntityAttribute("ignore")); 

        XMLStreamWriter xmlStreamWriter;
        ByteArrayOutputStream baos;

        try {
        if ( context.isRootEntity() )
        {
            baos = new ByteArrayOutputStream();
            xmlStreamWriter = XMLOutputFactory.newInstance().createXMLStreamWriter(baos, "UTF-8");
            xmlStreamWriter.writeStartDocument("utf-8", "1.0");
        }
        else
        {
            xmlStreamWriter = (XMLStreamWriter)context.getSessionAttribute(DOCUMENT_XML, SCOPE);
            baos = (ByteArrayOutputStream)context.getSessionAttribute(DOCUMENT_BA, SCOPE);
        }
        } catch (XMLStreamException e)
        {
            return null ;
        }

        if ( !ignoreElement )   //  Example: <entity name="eod" transformer="SQLTransformer" query="SELECT 'eof' as 'eof'"/>
        {
        try
            {
                xmlStreamWriter.writeStartElement(entity_name); // Open element...
        for ( String key : row.keySet() )
        {
                Object o = null ;
            try
            {
                o = row.get(key);
            }
            catch ( Exception e )
            {
            
            }

                if ( o == null )
                    continue ;

                String text = String.valueOf(o) ;
                if ( text.equalsIgnoreCase("null") )
                    continue ;

                xmlStreamWriter.writeStartElement(key);
                xmlStreamWriter.writeCharacters(text);
                xmlStreamWriter.writeEndElement();
        }
                if ( closeElement )
        xmlStreamWriter.writeEndElement();
            }
            catch ( Exception e )
            {
                return null;
            }

            context.setSessionAttribute(DOCUMENT_XML, xmlStreamWriter, SCOPE);
            context.setSessionAttribute(DOCUMENT_BA, baos, SCOPE);

            if ( !closeDocument )
                return row;
        }

        try {
            xmlStreamWriter.writeEndDocument();
            xmlStreamWriter.close();
            context.setSessionAttribute(DOCUMENT_XML, null, SCOPE);
        } catch (XMLStreamException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        DebugTrace.writeDebugFolder(debugTraceFolder, "sql2xml", baos.toByteArray());

        byte[] ba_schema ;
        try {
            ba_schema = DoTransform.PerformTransform(context, (String)params.get("normalize"), null, baos.toByteArray());
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            return null;
        }

        DebugTrace.writeDebugFolder( debugTraceFolder, "normalize", ba_schema);
        byte[] ba_solr ;
        try {
            ba_solr = DoTransform.PerformTransform(context, (String)params.get("importer"), row, ba_schema);
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            return null;
        }
        DebugTrace.writeDebugFolder(debugTraceFolder, "importer", ba_solr);

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
        for ( Iterator iterator = map.entrySet().iterator() ; iterator.hasNext() ;)
        {
            Map.Entry<String,ArrayList> entry = (Map.Entry)iterator.next();
            String key = entry.getKey();
            List list = entry.getValue();

            if ( list.size() == 1 )
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

    private boolean getEntityAttribute(String tmp) {
        return ( tmp == null )
                ? false
                : Boolean.parseBoolean(tmp);
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

        return doc ;
    }


    private final Log log = LogFactory.getLog(this.getClass());
}