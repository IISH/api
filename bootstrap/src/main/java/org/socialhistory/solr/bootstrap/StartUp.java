package org.socialhistory.solr.bootstrap;

import org.mortbay.jetty.Server;
import org.mortbay.jetty.webapp.WebAppContext;

/**
 * Created by IntelliJ IDEA.
 * User: lwo
 * Date: 9-jul-2009
 * Time: 10:49:29
 * <p/>
 * Startup our Jetty server to bootstrap our projects
 */

public class StartUp {

    private static StartUp server;

    public static void main(String... args) throws Exception {
        server = new StartUp();
        server.Start();
    }

    private Server Start() throws Exception {
        int port = 8080;
        Server server = new Server(port);

        // Solr home environment
        if (System.getProperty("solr.solr.home") == null)
            System.setProperty("solr.solr.home", "./solr-mappings/solr");

        System.setProperty("enable.master", "true");
        System.setProperty("enable.slave", "true");
        //System.setProperty("debug", "true");

        server.addHandler(new WebAppContext("./solr-mappings/solr-3.4.0.war", "/solr"));
        server.addHandler(new WebAppContext("./solr-mappings/solr/srw", "/styles"));
        server.addHandler(new WebAppContext("./widget/src/main/webapp", "/widget"));

        server.start();

        return server;
    }


}
