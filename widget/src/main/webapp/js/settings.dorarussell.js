// This ought to be set with the widget builder. 
var settings = {
    "query":{
        "version":"1.1",
        "operation":"searchRetrieve",
        "maximumRecords":10,
        "recordSchema":"info:srw/schema/1/mets",
        "recordPacking":"string"
    },
    "configInfo":{
        "containerlayoutratio":{search:2,result:3},
        "resultslayoutratio":{dt:1,dd:6},
        "interfieldoperator":"and",
        "relation":"all",
        "embedQuery":{"index":"iisg.identifier", "relation":"exact"},
        "allQuery":{"index":"iisg.collectionName", "relation":"exact","actualTerm":"dorarussell"},
        "baseUrl":"solr/mets/srw",
        "widgetId":"iish_widget_mets",
        "formSearch":"search",
        "formResult":"result",
        "formNavigate":"navigate",
        "maxPagingLinks":8,
        "waitingMessage":[
            {"$":"Searching...","@lang":"en-US"},
            {"$":"Zoeken...","@lang":"nl-NL"}
        ],
        "timeout":5000,
        "http.status":{
            "0":"You seem to have no connection to the internet.",
            "404":"URL of SRU server not found (HTTP 404). Please check your configuration or contact administrator.",
            "500":"Internal Server Error (HTTP 500). Please contact administrator",
            "parsererror":"Parsing the server's response failed.",
            "timeout":"Request Time out."
        },
        "embedparameters":{"url":"widget/js/widget.js"}
        ,
        "noSearchAndRetrieveResponse":"There was no result...",
        "title":[
            {"$":"Dora Winifred Russell Papers","@lang":"en-US"},
            {"$":"Dora Winifred Russell archief","@lang":"nl-NL"}
        ],
        "user_selections":[
            {"$":"Your selections","@lang":"en-US"},
            {"$":"Resultaat","@lang":"nl-NL"}
        ],
        "clear_all":[
            {"$":" (Clear all) ","@lang":"en-US"},
            {"$":" (Verwijderen) ","@lang":"nl-NL"}
        ],
        "separator":";",
        "searchbutton":"Search",
        //"searchEmptyOption":"-- No preference --",
        "shortlist":"shortlist",
        "languages":[
            {"$":"English","@lang":"en-US"},
            {"$":"Dutch","@lang":"nl-NL"}
        ],
        "lang_default":"nl-NL",
        "fadeIn":2000,
        "timeoutInputText":1000,
        "showAllRecordsInFirstView":false,
        "cssStylesheets":["widget/css/ui-lightness/jquery-ui-1.8rc1.custom.css","widget/css/ui-lightness/widget.css"],
        "cssClasses":{
            "search":"search ui-widget ui-widget-content ui-corner-all",
            "images":"search ui-widget ui-widget-content ui-corner-all",
            "navigate":"navigate ui-widget ui-widget-content ui-corner-all",
            "pager":"pager ui-widget ui-widget-content ui-corner-all",
            "resultset":"resultset ui-widget ui-widget-content ui-corner-all",
            "embededresultset":"embededresultset ui-widget ui-widget-content ui-corner-all",
            "shortlist":"shortlist",
            "fulllist":"fulllist",
            "embed":"ui-state-default ui-corner-all"}
    },
    "index":[
        {"type":"text","title":[
            {"@lang":"nl-NL","$":"Zoek naar"},
            {"@lang":"en-US","$":"Search for"}
        ],"map":{"name":{"@set":"cql","$":"serverChoice"}}},
        {"title":"Identifier","map":[
            {"name":{"@set":"migranten","$":"identifier"}},
            {"name":{"@set":"iisg","$":"identifier"}}
        ]},
        {"title":"IISH Collections","map":{"name":{"@set":"iisg","$":"collectionName"}}},
        {"type":"select", "shortlist":true,"title":[
            {"@lang":"en-US","$":"Series"},
            {"@lang":"nl-NL","$":"Serie"}
        ],"map":{"name":{"@set":"ead","$":"series"}}},
        {"type":"select","title":[
            {"@lang":"nl-NL","$":"Subseries"},
            {"@lang":"en-US","$":"Subseries"}
        ],"map":{"name":{"@set":"ead","$":"subseries"}}},
        {"type":"select", "sortlist":true,"title":[
            {"@lang":"nl-NL","$":"Folder"},
            {"@lang":"en-US","$":"File"}
        ],"map":{"name":{"@set":"ead","$":"file"}}},
        {"type":"select","title":[
            {"@lang":"nl-NL","$":"Item"},
            {"@lang":"en-US","$":"item"}
        ],"map":{"name":{"@set":"ead","$":"item"}}}
    ]}