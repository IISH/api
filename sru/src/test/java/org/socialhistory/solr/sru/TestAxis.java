package org.socialhistory.solr.sru;

import org.junit.Ignore;
import org.junit.Test;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;


/**
 * Created by IntelliJ IDEA.
 * User: lwo
 * Date: 18-aug-2009
 * Time: 13:39:29
 * To change this template use File | Settings | File Templates.
 */

@Ignore
public class TestAxis
{
    @Test
    public void LoadServer() throws Exception
    {

        String message = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
                " <soapenv:Body>\n" +
                "  <ns1:searchRetrieveRequest xmlns:ns1=\"http://www.loc.gov/zing/srw/\">\n" +
                "   <version xsi:type=\"xsd:string\">1.1</version>\n" +
                "   <query xsi:type=\"xsd:string\">afri?a</query>\n" +
                "   <startRecord xsi:type=\"xsd:positiveInteger\">1</startRecord>\n" +
                "   <maximumRecords xsi:type=\"xsd:nonNegativeInteger\">1</maximumRecords>\n" +
                "   <recordPacking xsi:type=\"xsd:string\">xml</recordPacking>\n" +
                "   <recordSchema xsi:type=\"xsd:string\">info:srw/schema/1/dc-v1.1</recordSchema>\n" +
                "   <recordXPath xsi:type=\"ns1:recordXPath\" xsi:nil=\"true\"/>\n" +
                "   <resultSetTTL xsi:type=\"ns1:resultSetTTL\" xsi:nil=\"true\"/>\n" +
                "   <sortKeys xsi:type=\"ns1:sortKeys\" xsi:nil=\"true\"/>\n" +
                "   <stylesheet xsi:type=\"ns1:stylesheet\" xsi:nil=\"true\"/>\n" +
                "   <extraRequestData xsi:type=\"ns1:extraRequestData\" xsi:nil=\"true\"/>\n" +
                "  </ns1:searchRetrieveRequest>\n" +
                " </soapenv:Body>\n" +
                "</soapenv:Envelope>";

        byte[] bytes = message.getBytes("UTF-8") ;

        try {
            // Construct data
            // Send data
            URL url = new URL("http://hostname:8080/solr/all/swr");
            URLConnection conn = url.openConnection();
            conn.setDoOutput(true);
            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            for ( byte b : bytes )
            {
                wr.write(b);
            }
            wr.flush();

            // Get the response
            BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = rd.readLine()) != null) {
                // Process line...
            }
            wr.close();
            rd.close();
        } catch (Exception e) {
        }

    }
}
