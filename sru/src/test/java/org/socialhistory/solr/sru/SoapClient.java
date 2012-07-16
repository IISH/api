package org.socialhistory.solr.sru;

import gov.loc.www.zing.srw.*;
import gov.loc.www.zing.srw.interfaces.SRWPort;
import gov.loc.www.zing.srw.service.SRWSampleServiceLocator;
import org.apache.axis.message.MessageElement;
import org.apache.axis.types.NonNegativeInteger;
import org.apache.axis.types.PositiveInteger;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Ignore;
import org.junit.Test;
import org.socialhistory.solr.sru.Config;

import javax.xml.rpc.ServiceException;
import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

/**
 * Created by IntelliJ IDEA.
 * User: lwo
 * Date: 2-aug-2009
 * Time: 17:35:53
 * To change this template use File | Settings | File Templates.
 */

@Ignore
public class SoapClient
{
    @Test
    public void test_searchRetrieveOperation() throws RemoteException {

        URL url= null;
        try {
            //url = new URL( "http://localhost:8080/services/SRW" );
            url = new URL( "http://localhost:8080/solr/srw" );
        } catch (MalformedURLException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        SRWSampleServiceLocator service = new SRWSampleServiceLocator();
        SRWPort port = null;
        try {
            port = service.getSRW(url);
        } catch (ServiceException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        SearchRetrieveRequestType request = new SearchRetrieveRequestType();

            request.setVersion("1.1");
            request.setQuery("dc.title=africa");
            request.setRecordSchema("info:srw/schema/1/dc-v1.1");
            request.setStartRecord(new PositiveInteger("1"));
            request.setMaximumRecords(new NonNegativeInteger("10"));
            request.setRecordPacking("xml");

            SearchRetrieveResponseType response = port.searchRetrieveOperation(request);
            log.info("postings="+response.getNumberOfRecords());
            RecordType[] record;

            RecordsType records=response.getRecords();

            if(records==null || (record=records.getRecord())==null)
                log.info("0 records returned");
            else {
                log.info(record.length+" records returned");
                log.info("record[0] has record number "+
                record[0].getRecordPosition());
                StringOrXmlFragment frag=record[0].getRecordData();
                MessageElement[] elems=frag.get_any();
                log.info("record="+elems[0].toString());
            }

            log.info("nextRecordPosition="+response.getNextRecordPosition());
    }

    private final Log log = LogFactory.getLog(Config.class);
}