package org.socialhistory.solr.importer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.solr.common.SolrException;
import org.apache.solr.common.util.NamedList;
import org.apache.solr.common.util.SimpleOrderedMap;
import org.apache.solr.core.SolrCore;
import org.apache.solr.handler.dataimport.DataImportHandler;
import org.apache.solr.request.SolrQueryRequest;
import org.apache.solr.response.SolrQueryResponse;
import org.apache.solr.request.SolrRequestHandler;
import org.apache.solr.util.plugin.SolrCoreAware;
import java.io.File;
import java.net.URL;
import java.util.Map;

/**
 * A special Handler that registers Import Handlers on a given file system.
 * The handler should be added in the solrconfig.xml document thus:
 * <requestHandler name="/dih" class="DataImportHandlers">
 * <lst name="default">
 * <str name="debugTraceFolder"/>
 * </lst>
 * <lst name="handlers">
 * <str name="collection1.subset_a.sequence"/>
 * <str name="collection1.subset_b.sequence"/>
 * <str name="collection2.subset_a.sequence"/>
 * <str name="collection2.subset_b.sequence"/>
 * </lst>
 * </requestHandler>
 */
public class DataImportHandlers implements SolrCoreAware, SolrRequestHandler {

    private NamedList initArgs = null;
    private final Log log = LogFactory.getLog(this.getClass());

    private static class StandardHandler {
        final String name;
        final SolrRequestHandler handler;

        public StandardHandler(String n, SolrRequestHandler h) {
            this.name = n;
            this.handler = h;
        }
    }

    /**
     * Save the args and pass them to each standard handler
     */
    public void init(NamedList args) {
        this.initArgs = args;
    }

    public void inform(SolrCore core) {

        if (initArgs.size() == 0)
            return;

        String path = null;
        for (Map.Entry<String, SolrRequestHandler> entry : core.getRequestHandlers().entrySet()) {
            if (entry.getValue() == this) {
                path = entry.getKey();
                break;
            }
        }
        if (path == null) {
            log.warn("The DataImportHandlers is not registered with the current core: " + core.getName());
            return;
        }
        if (!path.startsWith("/")) {
            throw new SolrException(SolrException.ErrorCode.SERVER_ERROR,
                    "The DataImportHandlers needs to be registered to a path. Typically this is '/dih'");
        }
        // Remove the parent handler
        core.registerRequestHandler(path, null);
        if (!path.endsWith("/")) {
            path += "/";
        }

        addHandlers(core, path);
    }

    private void addHandlers(SolrCore core, String path) {

        final NamedList handlers = (NamedList) initArgs.get("handlers");
        final NamedList defaults = (NamedList) initArgs.get("defaults");

        for (int i = 0; i < handlers.size(); i++) {
            final String name = handlers.getName(i);
            final DataImportHandler dataImportHandler = new DataImportHandler();
            final StandardHandler handler = new StandardHandler(name, dataImportHandler);
            if (core.getRequestHandler(path + name) == null) {

                final NamedList list = new NamedList();
                final String config = getListValue(defaults, "importer", "import/") + name + ".xml";
                File file = new File(core.getSolrConfig().getResourceLoader().getConfigDir(), config);
                if (!file.exists()) {
                    log.warn("Dataimport handler not found: " + file.getAbsolutePath());
                    log.info("Skipping loading the handler because of the above warning about " + name);
                    continue;
                }

                list.add("config", config);
                list.add("normalize", getListValue(defaults, "normalize", "normalize/") + name + ".xsl");
                list.add("importer", getListValue(defaults, "importer", "import/") + "add.xsl");
                list.add("resource", getListValue(defaults, "resource", "resource/" + name + ".xsl"));
                final String debugTraceFolder = (String) defaults.get("debugTraceFolder");
                if (debugTraceFolder != null || !debugTraceFolder.isEmpty()) {
                    final String folder = (debugTraceFolder.endsWith(File.separator))
                            ? debugTraceFolder
                            : debugTraceFolder + File.separator;
                    list.add("debugTraceFolder", folder + name);
                }
                final SimpleOrderedMap<NamedList> init = new SimpleOrderedMap<NamedList>();
                init.add("defaults", list);
                handler.handler.init(init);
                core.registerRequestHandler(path + name, handler.handler);
                dataImportHandler.inform(core);
            }
        }
    }

    private String getListValue(NamedList list, String name, String defaults) {

        final String value = (String) list.get(name);
        return (value == null)
                ? defaults : value;
    }


    public void handleRequest(SolrQueryRequest req, SolrQueryResponse rsp) {
        throw new SolrException(SolrException.ErrorCode.SERVER_ERROR,
                "The DataImportHandlers should never be called directly");
    }

    //////////////////////// SolrInfoMBeans methods //////////////////////

    public String getDescription() {
        return "Register Standard DataImportHandler Handlers";
    }

    public String getVersion() {
        return "$Revision: 608150 $";
    }

    public String getSourceId() {
        return "$Id: DataImportHandlers.java $";
    }

    public String getSource() {
        return "$URL: DataImportHandlers.java $";
    }

    public Category getCategory() {
        return Category.QUERYHANDLER;
    }

    public URL[] getDocs() {
        return null;
    }

    public String getName() {
        return this.getClass().getName();
    }

    public NamedList getStatistics() {
        return null;
    }
}
