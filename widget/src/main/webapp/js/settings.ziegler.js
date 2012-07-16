// This ought to be set with the widget builder. 
var settings = {
    "query":{
        "version":"1.1",
        "operation":"searchRetrieve",
        "maximumRecords":10,
        "recordSchema":"info:srw/schema/1/ziegler",
        "recordPacking":"string"
    },
    "configInfo":{
        "containerlayoutratio":{search:2,result:3},
        "resultslayoutratio":{dt:1,dd:6},
        "interfieldoperator":"and",
        "relation":"all",
        "embedQuery":{"index":"iisg.identifier", "relation":"exact"},
        "allQuery":{"index":"iisg.collectionName", "relation":"exact","actualTerm":"ziegler"},
        "baseUrl":"solr/ziegler/srw",
        "widgetId":"iish_widget_ziegler_v1_1",
        "formSearch":"search",
        "formResult":"result",
        "formNavigate":"navigate",
        "maxPagingLinks":8,
        "waitingMessage":[{"$":"Searching...","@lang":"en-US"},{"$":"Zoeken...","@lang":"nl-NL"}],
        "timeout":5000,
        "http.status":{
            "0":"You seem to have no connection to the internet.",
            "404":"URL of SRU server not found (HTTP 404). Please check your configuration or contact administrator.",
            "500":"Internal Server Error (HTTP 500). Please contact administrator",
            "parsererror":"Parsing the server's response failed.",
            "timeout":"Request Time out."
        },
"embedparameters":{"url":"widget/js/widget.js"},
        "noSearchAndRetrieveResponse":"There was no result...",
        "title":[{"$":"Search Ziegler database","@lang":"en-US"},{"$":"Zoeken in Ziegler database","@lang":"nl-NL"},{"$":"Ziegler Datenbank durchsuchen","@lang":"de-DE"}],  //TODO:deutsch
        "user_selections":[{"$":"Your selections","@lang":"en-US"},{"$":"Resultaat","@lang":"nl-NL"},{"$":"","@lang":"de-DE"}],   //TODO:deutsch
        "clear_all":[{"$":"Clear all","@lang":"en-US"},{"$":"Verwijderen","@lang":"nl-NL"},{"$":"","@lang":"de-DE"}],             //TODO:deutsch
        "separator":";",
        "searchbutton":"Search",
        //"searchEmptyOption":"-- No preference --",
        "shortlist":"shortlist",
        "languages":[{"$":"English","@lang":"en-US"},{"$":"Nederlands","@lang":"nl-NL"},{"$":"Deutsch","@lang":"de-DE"}],
        "lang_default":"de-DE",
        "fadeIn":2000,
        "timeoutInputText":1000,
        "showAllRecordsInFirstView":false,
	"cssStylesheets":["widget/css/ui-lightness/jquery-ui-1.8rc1.custom.css","widget/css/ui-lightness/widget.css", "widget/css/skins/tango/skin.css"],
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
        {"@lang":"en-US","$":"Search all"},
        {"@lang":"de-DE","$":""}
    ],"map":{"name":{"@set":"cql","$":"serverChoice"}}},

    {"type":"select","title":[
        {"@lang":"de-DE","$":"Signatur"}
    ],
    "map":{"name":{"@set":"ziegler","$":"Signatur"}}},

    {"type":"text","title":[
        {"@lang":"de-DE","$":"Jahr"},{"@lang":"en-US","$":"Year"},{"@lang":"nl-NL","$":"Jaar"}
    ],"map":{"name":{"@set":"ziegler","$":"Jahr"}}},

    {"type":"select","title":[
        {"@lang":"de-DE","$":"Quelle"}
    ],"map":{"name":{"@set":"ziegler","$":"origin"}}},

    {"type":"text","title":[
        {"@lang":"de-DE","$":"Namen"}
    ],"map":{"name":{"@set":"ziegler","$":"Namen"}}},

    {"type":"text","title":[
        {"@lang":"de-DE","$":"Vornamen"}
    ],"map":{"name":{"@set":"ziegler","$":"Vornamen"}}},

    {"type":"select","title":[
        {"@lang":"de-DE","$":"Amt"}
    ],"map":{"name":{"@set":"ziegler","$":"Amt"}}},

    {"type":"text","title":[
        {"@lang":"de-DE","$":"Ortschaft"}
    ],"map":{"name":{"@set":"ziegler","$":"Ortschaft"}}},

    {"type":"text","title":[
        {"@lang":"de-DE","$":"Wohin"}
    ],"map":{"name":{"@set":"ziegler","$":"Wohin"}}},

    {"type":"text","title":[
        {"@lang":"de-DE","$":"Fabrik"}
    ],"map":{"name":{"@set":"ziegler","$":"Fabrik"}}},

    {"type":"text","title":[
        {"@lang":"de-DE","$":"Arbeit"}
    ],"map":{"name":{"@set":"ziegler","$":"Arbeit"}}}
]}