// This ought to be set with the widget builder. 
var settings = {
    "query":{
        "version":"1.1",
        "operation":"searchRetrieve",
        "maximumRecords":10,
        "recordSchema":"info:srw/schema/1/migranten",
        "recordPacking":"string"
    },
    "configInfo":{
        "containerlayoutratio":{search:2,result:3},
        "resultslayoutratio":{dt:1,dd:6},
        "interfieldoperator":"and",
        "relation":"all",
        "embedQuery":{"index":"iisg.identifier", "relation":"exact"},
        "allQuery":{"index":"iisg.collectionName", "relation":"exact","actualTerm":"migranten"},
        "baseUrl":[{"$":"solr/migranten/srw_en","@lang":"en-US"},{"$":"solr/migranten/srw_nl","@lang":"nl-NL"}],
        "widgetId":"iish_widget_migranten_v1_1",
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
        "title":[{"$":"Find an organization","@lang":"en-US"},{"$":"Vind een organisatie","@lang":"nl-NL"}],
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
    {"title":"Identifier","map":[
        {"name":{"@set":"migranten","$":"identifier"}},
        {"name":{"@set":"iisg","$":"identifier"}}
    ]},
    {"title":"IISH Collections","map":{"name":{"@set":"iisg","$":"collectionName"}}},
    {"type":"text", "shortlist":true,"title":[
        {"@lang":"en-US","$":"Name"},
        {"@lang":"nl-NL","$":"Naam"}
    ],"map":{"name":{"@set":"migranten","$":"naam"}}},
    {"type":"select","shortlist":true,"title":[
        {"@lang":"en-US","$":"Location"},
        {"@lang":"nl-NL","$":"Plaats"}
    ],"map":{"name":{"@set":"migranten","$":"plaats"}}},
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Land"},
        {"@lang":"en-US","$":"Country"}
    ],"map":{"name":{"@set":"migranten","$":"land"}}},
    {"type":"select", "sortlist":true,"title":[
        {"@lang":"nl-NL","$":"Etniciteit"},
        {"@lang":"en-US","$":"Ethnicity"}
    ],"map":{"name":{"@set":"migranten","$":"etniciteit"}}},
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Religie"},
        {"@lang":"en-US","$":"Religion"}
    ],"map":{"name":{"@set":"migranten","$":"religie"}}},
    {"type":"select","shortlist":true,"title":[
        {"@lang":"nl-NL","$":"Rechtsvorm"},
        {"@lang":"en-US","$":"Type of institution"}
    ],"map":{"name":{"@set":"migranten","$":"soort"}}},
    {"type":"select","shortlist":true,"title":[
        {"@lang":"nl-NL","$":"Doelstelling"},
        {"@lang":"en-US","$":"Objective"}
    ],"map":{"name":{"@set":"migranten","$":"doelstelling"}}},
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Doelgroep"},
        {"@lang":"en-US","$":"Target group"}
    ],"map":{"name":{"@set":"migranten","$":"doelgroep"}}},
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Schaal"},
        {"@lang":"en-US","$":"Scale"}
    ],"map":{"name":{"@set":"migranten","$":"schaal"}}},
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Stichtingsjaar"},
        {"@lang":"en-US","$":"Date of foundation"}
    ],"map":{"name":{"@set":"migranten","$":"stichtingsjaar"}}},
    {"type":"select","title":[
        {"@lang":"nl-NL","$":"Opgeheven"},
        {"@lang":"en-US","$":"Discontinued"}
    ],"map":{"name":{"@set":"migranten","$":"opgeheven"}}}
]}