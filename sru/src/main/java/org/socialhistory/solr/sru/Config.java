/*
Copyright 2010 International Institute for Social History, The Netherlands.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
    Config.java
    Load and initialize the properties such as the OCLC database, Explain settings and mappings, etc.
*/


package org.socialhistory.solr.sru;


import ORG.oclc.os.SRW.Utilities;
import org.apache.axis.configuration.FileProvider;
import org.apache.axis.server.AxisServer;
import org.apache.axis.utils.XMLUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.SimpleFSDirectory;
import org.apache.solr.common.util.DOMUtil;
import org.apache.solr.common.util.NamedList;
import org.apache.solr.core.SolrResourceLoader;
import org.apache.solr.search.SolrIndexReader;
import org.w3c.dom.*;
import org.xml.sax.SAXException;
import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.*;
import java.io.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Config.java
 * <p/>
 * Initializes all common resources: the axis server and loads the explain XML document into the CQL-2-Lucene list
 */
class Config {
    /**
     * Reads all configuration parameters and loads the CQL-2-Lucene list into memory.
     *
     * @param args Solr namedlist parameters as they were set in the solrconfig core document.
     * @return An instance of a SolrSRWDatabase.
     * @throws Exception
     */
    public SolrSRWDatabase init(NamedList args) throws Exception {

        NamedList srw_properties = (NamedList) args.getAll("srw_properties").get(0);

        Properties properties = new Properties();
        for (int i = 0; i < srw_properties.size(); i++) {
            String field_name = srw_properties.getName(i);
            properties.setProperty(field_name, String.valueOf(srw_properties.getVal(i)));
        }

        getExplainVariables(properties);

        if (!properties.containsKey("SRW.Context"))
            properties.setProperty("SRW.Context", solr_solr_home);

        if (!properties.containsKey("dbHome"))
            properties.setProperty("dbHome", properties.getProperty("SRW.Context"));

        if (!properties.containsKey("SRW.Home"))
            properties.setProperty("SRW.Home", properties.getProperty("SRW.Context"));

        String host = properties.getProperty("serverInfo.host", "http://localhost/solr/srw");
        properties.setProperty("serverInfo.host", host);  // Assumption
        String port = properties.getProperty("serverInfo.port", "8080");
        properties.setProperty("serverInfo.port", port); // Assumption

        if (!properties.containsKey("serverInfo.port"))
            properties.setProperty("serverInfo.port", "");

        setSolr = properties.getProperty("solr.identifier");
        if (setSolr == null)
            setSolr = "info:srw/cql-context-set/2/solr";  // Assumption

        String dbkey = properties.getProperty("databaseInfo.title", properties.getProperty("serverInfo.database", properties.getProperty("dbname", SolrSRWDatabase.class.getSimpleName())));
        String dbname = (SolrSRWDatabase.dbs.containsKey(dbkey))
                ? dbkey + ".instance" + String.valueOf(++c)
                : dbkey;

        properties.setProperty("db." + dbname + ".class", SolrSRWDatabase.class.getName());
        SolrSRWDatabase db = (SolrSRWDatabase) SolrSRWDatabase.getDB(dbname, properties);
        if (db.getAxisServer() == null) // We only need to initialize the axis server once.
            db.setAxisServer(GetAxisServer());
        Map<String, ArrayList> explainMap = getExplainMap(properties.getProperty("explain"));
        db.setExplainMap(explainMap);
        db.setFacets(getFacets(args.get("facets"), explainMap));

        xml2json_callback_key = properties.getProperty("xml-2-json.callbackkey");

        return db;
    }

    private void getExplainVariables(Properties properties) throws IOException, SAXException, ParserConfigurationException, XPathExpressionException {

        File f = Utilities.findFile(properties.getProperty("explain"), null, solr_solr_home);
        Document doc = GetDOMDocument(f);

        NodeList infos = GetNodes(doc, "zr:explain/zr:serverInfo | zr:explain/zr:databaseInfo | zr:explain/zr:metaInfo");
        for (int i = 0; i < infos.getLength(); i++) {
            Element info = (Element) infos.item(i);
            NodeList c = info.getChildNodes();
            for (int j = 0; j < c.getLength(); j++) {
                Node node = c.item(j);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    String text = node.getTextContent();
                    if (text != null)
                        properties.setProperty(info.getLocalName() + "." + node.getLocalName(), text);
                }
            }
        }
    }

    private NamedList getFacets(Object o, Map<String, ArrayList> indexFields) {
        if (o == null)
            return null;

        boolean added = false;

        NamedList facets = (NamedList) o;
        List facet_fields = facets.getAll("facet.field");

        for (Object facet_field : facet_fields) {
            String cql_facet_field = (String) facet_field;
            List list = indexFields.get(SolrSRWDatabase.IndexOptions.scan_exact + "." + cql_facet_field);
            if (list == null)
                list = indexFields.get(SolrSRWDatabase.IndexOptions.scan + "." + cql_facet_field);
            if (list == null) {
                log.warn("The facet.field=" + cql_facet_field + " does not map to a know Lucene index field and will be ignored.");
                continue;
            }

            // This list is used for the getExtraResponseData.
            // We want to know the mapping from CQL to Lucene fields.
            facets.add(cql_facet_field, list);
            added = true;
        }

        if (added)
            return facets;

        return null;
    }

    private void CollectIndices(String solr_data, ArrayList indexFields) {
        File index_folder = new File(solr_data);
        if (!index_folder.isDirectory())
            return;

        if (!index_folder.getName().equalsIgnoreCase("index")) {
            String[] folders = index_folder.list();
            for (String folderName : folders) {
                CollectIndices(GetFolder(solr_data) + File.separator + folderName, indexFields);
            }

            return;
        }

        Collection col;
        try {
            FSDirectory fs = SimpleFSDirectory.open(index_folder);
            IndexReader indexReader = SolrIndexReader.open(fs, true);
            col = indexReader.getFieldNames(IndexReader.FieldOption.INDEXED);
            indexReader.close();
        } catch (Exception e) { // Possible of course, if it is not a Lucene directory.
            return;
        }

        for (Object aCol : col) {
            String item = (String) aCol;
            indexFields.add(item);
        }
    }


    private Map<String, ArrayList> getExplainMap(String explain_file) throws IOException, SAXException, ParserConfigurationException, XPathExpressionException {
        ArrayList<String> indexFields = new ArrayList(); // I do not like it like this...
        CollectIndices(dataDir, indexFields);

        Map<String, ArrayList> explainMap = new HashMap();

        SolrSRWDatabase.IndexOptions[] options = SolrSRWDatabase.IndexOptions.values();

        // get fields and indexed fields
        File f = Utilities.findFile(explain_file, null, solr_solr_home);
        Document doc = GetDOMDocument(f);

        NodeList schemaInfos = GetNodes(doc, "zr:explain/zr:indexInfo/zr:set[not(@identifier='" + setSolr + "')]");

        for (int i = 0; i < schemaInfos.getLength(); i++) {
            Element schema = (Element) schemaInfos.item(i);
            String identifier = DOMUtil.getAttr(schema, "identifier");
            log.info("Adding set " + identifier);

            String name = DOMUtil.getAttr(schema, "name");
            String xquery = "zr:map/zr:name[@set='" + name + "']";

            NodeList indexInfos = GetNodes(doc, "zr:explain/zr:indexInfo/zr:index");
            for (int l = 0; l < indexInfos.getLength(); l++) {
                Element indexInfo = (Element) indexInfos.item(l);

                NodeList indices = GetNodes(indexInfo, xquery);
                for (int j = 0; j < indices.getLength(); j++) {
                    String key = indices.item(j).getTextContent();
                    Element element_name = (Element) indices.item(j);

                    for (SolrSRWDatabase.IndexOptions option1 : options) {
                        String option = option1.name();
                        ArrayList list = GetSolrIndices(indexFields, element_name, option);
                        int index = option.indexOf("_");
                        String alt_option = (index == -1)
                                ? option
                                : option.substring(0, index);

                        Attr attr;
                        if (indexInfo.hasAttribute(alt_option))
                            attr = indexInfo.getAttributeNode(alt_option);
                        else {
                            attr = doc.createAttribute(alt_option);
                            indexInfo.setAttributeNode(attr);
                        }

                        if (list.size() == 0 && !attr.getValue().equals("true"))
                            attr.setValue("false");
                        else {
                            attr.setValue("true");
                            String index_name = name + "." + key;
                            explainMap.put(option + "." + index_name, list);

                            Node title = GetNode(element_name.getParentNode().getParentNode(), "title");
                            if (title != null) {
                                ArrayList title_list = new ArrayList();
                                title_list.add(title.getTextContent());

                                explainMap.put("index.title." + index_name, title_list);
                            }
                        }


                    }
                }
            }
        }

        // remove all CQL mappings with no solr index mapped to it...
        NodeList solr_set = GetNodes(doc, "//zr:index[not(zr:map/zr:name/@set='solr')]/zr:map");
        for (int i = solr_set.getLength() - 1; i != -1; i--) {
            Node child = solr_set.item(i);
            child.getParentNode().removeChild(child);
        }

        // Remove all indexes without a CQL map.
        solr_set = GetNodes(doc, "//zr:index[not(zr:map)]");
        for (int i = solr_set.getLength() - 1; i != -1; i--) {
            Node child = solr_set.item(i);
            child.getParentNode().removeChild(child);
        }


        // Remove all solr map references
        solr_set = GetNodes(doc, "//zr:map[not(zr:name/@set!='solr')]"); // All solr maps, without other schema.
        for (int i = solr_set.getLength() - 1; i != -1; i--) {
            Node child = solr_set.item(i);
            child.getParentNode().removeChild(child);
        }


        // Remove all solr sets
        solr_set = GetNodes(doc, "//zr:name[@set='solr']"); // All remaining solr names.
        for (int i = solr_set.getLength() - 1; i != -1; i--) {
            Node child = solr_set.item(i);
            child.getParentNode().removeChild(child);
        }

        // Merge scan, search and sort indexes with the same name.


        // If there is an element:
        // <set name="solr" identifier="info:srw/cql-context-set/2/solr"/>
        // We want to be able to search indexed solr fields, so...
        Node indexInfoSolr = GetNode(doc, "zr:explain/zr:indexInfo/zr:set[@identifier='" + setSolr + "']");
        if (indexInfoSolr != null) {
            Node schemaInfoSolr = GetNode(doc, "zr:explain/zr:schemaInfo/zr:schema[@identifier='" + setSolr + "']");
            if (schemaInfoSolr == null)
                log.info("The explain/indexInfo/set[@identifier='" + setSolr + "'] was declared, but no corresponding output format was defined in the explain/schemaInfo element.");

            Node title = (schemaInfoSolr == null)
                    ? null
                    : GetNode(schemaInfoSolr, "zr:title");

            String Title = (title == null)
                    ? setSolr
                    : title.getTextContent();

            StringBuilder sb = new StringBuilder("<index search='true' scan='true'><title>" + Title + "</title>");
            for (Object indexField : indexFields) {
                String key = (String) indexField;
                ArrayList list = new ArrayList(1);
                list.add(key);
                explainMap.put("search.solr." + key, list);

                sb.append("<map><name set='solr'>").append(key).append("</name></map>");
            }
            sb.append("</index>");

            // Cast our string to a document
            ByteArrayInputStream bais = new ByteArrayInputStream(sb.toString().getBytes("utf-8")); // Would not be utf-8 ?
            DocumentBuilder db = XMLUtils.getDocumentBuilder();
            Document doc_solr = db.parse(bais);
            XMLUtils.releaseDocumentBuilder(db);

            // Add the document to the explain document.
            Node child = doc.importNode(doc_solr.getDocumentElement(), true);
            Node indexInfo = GetNode(doc, "zr:explain/zr:indexInfo");
            indexInfo.appendChild(child);
        }

        // Gather all information elements
        NodeList info = GetNodes(doc, "zr:explain/zr:*");
        for (int i = 0; i < info.getLength(); i++) {
            Element element = (Element) info.item(i);

            NodeList children = element.getChildNodes();
            ArrayList list = new ArrayList(children.getLength());
            for (int j = 0; j < children.getLength(); j++) {
                if (children.item(j).getNodeType() == Node.ELEMENT_NODE) {
                    Element child;
                    try {
                        child = (Element) children.item(j);
                    } catch (Exception e) {
                        log.warn(e);
                        continue;
                    }

                    list.add(XMLUtils.ElementToString(child));
                }
            }
            explainMap.put("explain." + element.getLocalName(), list);
        }

        return explainMap;
    }

    private ArrayList GetSolrIndices(ArrayList indexFields, Element name, String option) throws XPathExpressionException {
        ArrayList<String> list = new ArrayList();

        /* Sibling map elements that only relate to a specific index
       <index search="true" scan="true">
           <title>Title</title>
           <map>
               <name set="dc">title</name>
               <name set="solr">marc_245</name> ==> Maps to dc.title
               <name set="solr">marc_246</name> ==> Maps to dc.title aswell
               <name set="solr" search="marc_246" /> ==> Maps to dc.title too
           </map>
        */

        ArrayList<Element> removal = new ArrayList();

        Element map_name = (Element) name.getParentNode();
        NodeList solr_indices = GetNodes(map_name, "zr:name[@set='solr' and @" + option + "]");
        for (int i = 0; i < solr_indices.getLength(); i++) {
            Element map = (Element) solr_indices.item(i);
            String opt = DOMUtil.getAttr(map, option);
            boolean match = AddToList(indexFields, list, opt);
            if (!match)
                removal.add(map);
        }

        /* Parent map elements that cover all indices mentioned.
            Example:
            <index search="true" scan="false">
                <title>Identifier</title>
                <map><name set="dc">identifier</name></map>
                <map><name set="marc">controlfield.001</name></map>
                <map><name set="solr">marc_controlfield_001</name></map> ==> Maps to dc.identifier and marc.controlfield.001
            </index>
        */

        Element index = (Element) name.getParentNode().getParentNode();
        solr_indices = GetNodes(index, "zr:map[not(zr:name/@set!='solr')]/zr:name[@set='solr' and @" + option + "]");
        for (int i = 0; i < solr_indices.getLength(); i++) {
            Element map = (Element) solr_indices.item(i);
            String opt = DOMUtil.getAttr(map, option);
            boolean match = AddToList(indexFields, list, opt);
            if (!match)
                removal.add(map);
        }

        for (int i = removal.size() - 1; i != -1; i--) {
            Element element = removal.get(i);
            element.getParentNode().removeChild(element);
        }

        return list;
    }

    private boolean AddToList(ArrayList indexFields, ArrayList list, String indexname) {
        if (indexname == null)
            return false;

        if (indexFields.contains(indexname)) {
            list.add(indexname);
            return true;
        }

        Pattern pattern = Pattern.compile(indexname, Pattern.CASE_INSENSITIVE);

        boolean match = false;
        for (Object indexField : indexFields) {
            String key = (String) indexField;

            if (list.contains(key))
                continue;

            Matcher matcher = pattern.matcher(key);
            if (matcher.find()) {
                list.add(key);
                match = true;
            }
        }

        if (!match)
            log.warn("The Lucene index field '" + indexname + "' is mentioned in the crosswalk explain.xml document, but it does not (yet) occur in the index. It will not show up in the explain record.");

        return match;
    }

    private Document GetDOMDocument(File file) throws ParserConfigurationException, IOException, SAXException {

        DocumentBuilder db = XMLUtils.getDocumentBuilder();
        Document doc = db.parse(file);
        doc.getDocumentElement().normalize();
        XMLUtils.releaseDocumentBuilder(db);

        return doc;
    }

    /*
    private String GetAttributeValue(Element element, String TagName)
    {
        Attr attribute = element.getAttributeNode(TagName) ;
        String text = ( attribute == null )
                ? null
                : attribute.getValue() ;
        
        return text ;
    }
    */

    private Node GetNode(Object item, String xquery) throws XPathExpressionException {
        XPathExpression expr = getXPathExpression(xquery);
        Node node = (Node) expr.evaluate(item, XPathConstants.NODE);

        return node;
    }

    private NodeList GetNodes(Object item, String xquery) throws XPathExpressionException {
        XPathExpression expr = getXPathExpression(xquery);
        NodeList nodelist = (NodeList) expr.evaluate(item, XPathConstants.NODESET);

        return nodelist;
    }

    private XPathExpression getXPathExpression(String xquery) throws XPathExpressionException {
        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();

        // http://www.ibm.com/developerworks/library/x-javaxpathapi.html
        NamespaceContext ns = new NamespaceContext() {

            @Override
            public String getPrefix(String namespaceURI) {
                throw new UnsupportedOperationException();
            }

            @Override
            public Iterator getPrefixes(String namespaceURI) {
                throw new UnsupportedOperationException();
            }

            @Override
            public String getNamespaceURI(String prefix) {

                if (prefix == null)
                    throw new NullPointerException("Null prefix");
                if (prefix.equalsIgnoreCase("zr"))
                    return "http://explain.z3950.org/dtd/2.0/";
                if (prefix.equalsIgnoreCase("srw"))
                    return "http://www.loc.gov/zing/srw/";
                if (prefix.equalsIgnoreCase("xml"))
                    return XMLConstants.XML_NS_URI;
                return XMLConstants.NULL_NS_URI;
            }
        };

        xpath.setNamespaceContext(ns);
        XPathExpression expr = xpath.compile(xquery);
        return expr;
    }

    AxisServer GetAxisServer() throws FileNotFoundException {

        InputStream is = new FileInputStream(solr_solr_home + File.separator + "srw" + File.separator + "deploy.wsdd");
        FileProvider provider = new FileProvider(is);
        AxisServer server = new AxisServer(provider);
        return server;
    }

    public String getXml2json_callback_key() {

        return xml2json_callback_key;
    }

    /**
     * Utility method. It ensures a folder url ends with a slash.
     *
     * @param folder The path of a folder
     * @return the folder with a trailing slash
     */
    private String GetFolder(String folder) {
        if (folder == null)
            return null;

        File f = new File(folder);
        String tmp = f.getAbsolutePath().replace("./", "").replace(".\\", "");
        String ret = (tmp.endsWith("/") || tmp.endsWith("\\"))
                ? tmp.substring(0, tmp.length() - 1)
                : tmp;

        return ret;
    }

    private static int c;
    private final String solr_solr_home;
    private String dataDir;
    private String setSolr, xml2json_callback_key;

    /**
     * Class constructor
     * <p/>
     * Locates the main solr home directory solr.solr.home
     * Typically this can be set with a VM parameter or is set by Solr itself.
     * Needed to load configuration files for the SRW
     * @param dataDir
     */
    public Config(String dataDir) {
        // Find the application's solr home folder
        String temp_solr_solr_home = GetFolder(SolrResourceLoader.locateSolrHome());
        if (temp_solr_solr_home == null)
            temp_solr_solr_home = GetFolder(System.getProperty("solr.solr.home"));

        if (temp_solr_solr_home == null) //  O dear...
        {
            log.warn("Could not find the Solr Home setting: solr.solr.home");
            log.warn("Please set the property as a VM startup parameter: -Dsolr.solr.home=/such/and/such/folder");
            temp_solr_solr_home = "."; // Assumption.
        }

        this.solr_solr_home = temp_solr_solr_home;
        this.dataDir = dataDir;
    }

    private final Log log = LogFactory.getLog(Config.class);
}