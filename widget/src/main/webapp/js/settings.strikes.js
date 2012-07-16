// This ought to be set with the widget builder. 
var settings = {
    "query":{
        "version":"1.1",
        "operation":"searchRetrieve",
        "maximumRecords":10,
        "recordSchema":"info:srw/schema/1/strikes",
        "recordPacking":"string"
    },
    "configInfo":{
        "containerlayoutratio":{search:2,result:3},
        "resultslayoutratio":{dt:1,dd:6},
        "interfieldoperator":"and",
        "relation":"all",
        "embedQuery":{"index":"iisg.identifier", "relation":"exact"},
        "allQuery":{"index":"iisg.collectionName", "relation":"exact","actualTerm":"strikes"},
        "baseUrl":[{"$":"solr/strikes/srw_en","@lang":"en-US"},{"$":"solr/strikes/srw_nl","@lang":"nl-NL"}],
        "widgetId":"iish_widget_strikes_v1_1",
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
        "title":[{"$":"Strikes","@lang":"en-US"},{"$":"Stakingen","@lang":"nl-NL"}],
        "user_selections":[{"$":"Your selections","@lang":"en-US"},{"$":"Resultaat","@lang":"nl-NL"}],
        "clear_all":[{"$":"Clear all","@lang":"en-US"},{"$":"Verwijderen","@lang":"nl-NL"}],
        "separator":";",
        "searchbutton":"Search",
        //"searchEmptyOption":"-- No preference --",
        "shortlist":"shortlist",
        "languages":[{"$":"English","@lang":"en-US"},{"$":"Dutch","@lang":"nl-NL"}],
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
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Actiesoort"},
        {"@lang":"en-US","$":"Action"}
    ],"map":{"name":{"@set":"strikes","$":"actiesoort"}}}
            ,
    {"type":"text","title":[
        {"@lang":"nl-NL","$":"Bedrijf"},
        {"@lang":"en-US","$":"Company"}
    ],"map":{"name":{"@set":"strikes","$":"bedrijf"}}}
            ,
    {"type":"text","title":[
        {"@lang":"nl-NL","$":"Plaats"},
        {"@lang":"en-US","$":"City"}
    ],"map":{"name":{"@set":"strikes","$":"plaats"}}}
            ,
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Beroep"},
        {"@lang":"en-US","$":"Occupation"}
    ],"map":{"name":{"@set":"strikes","$":"beroepsgroep"}}}
            ,
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Sector"},
        {"@lang":"en-US","$":"Sector"}
    ],"map":{"name":{"@set":"strikes","$":"sector"}}}
            ,
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Reden"},
        {"@lang":"en-US","$":"Goal"}
    ],"map":{"name":{"@set":"strikes","$":"reden"}}}
            ,
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Type"},
        {"@lang":"en-US","$":"Type"}
    ],"map":{"name":{"@set":"strikes","$":"type"}}}
            ,
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Uitkomst"},
        {"@lang":"en-US","$":"Result"}
    ],"map":{"name":{"@set":"strikes","$":"uitkomst"}}}
            ,
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Karakter"},
        {"@lang":"en-US","$":"Nature"}
    ],"map":{"name":{"@set":"strikes","$":"karakter"}}}
            ,
    {"type":"text","title":[
        {"@lang":"nl-NL","$":"Jaar"},
        {"@lang":"en-US","$":"Year"}
    ],"map":{"name":{"@set":"strikes","$":"jaar"}}}
]}