            // try adding a line
var contextSet = null;
var url = '';
var lang = 'en-US';
url = "http://api.iisg.nl/solr/migranten/srw?operation=explain&callback=?";
var settings = new Object();
function getLabelFromObject(obj) {
	var label;
	if ($.isArray(obj)) {
		$(obj).each(function(ix,data) {
			if ($(data).attr('@lang') == lang) {
				label = $(data).attr('$');
			}
		});
	} else {
		label = obj;
	}
	return label ;
}
function appendFieldRow(field,fieldIndex) {
	$("#widgetFields tbody").append($('<tr>')

		.append($('<td>')
			.append(getLabelFromObject(field.title))
		)
		.append($('<td>') // hidden radio
			.append($('<select name="type-'+fieldIndex+'"/>')
				.append(new Option('Hidden','hidden'))
				.append(new Option('Text','text',true))
					.append($(field).attr('@scan') == true ? new Option('Dropdown','select'):'')
			)
		)
		.append($('<td>')
			.append('<input type="checkbox" name="shortlist-'+fieldIndex+'" checked />')
		)
//		.append($('<td>')
//			.append($(field).attr('@sort') == true ? '<input type="radio" name="query.sortkey_0" value="'+field.title+'" />' : '')
//		)
	); // </tr>
	fieldIndex++;
}
function randomWidgetId() {
	var chars = "0123456789abcdef";
	var string_length = 8;
	var widgetId = '';
	for (var i=0; i<string_length; i++) {
		var rnum = Math.floor(Math.random() * chars.length);
		widgetId += chars.substring(rnum,rnum+1);
	}
	return widgetId;
}

function initiateSettings(objData) {
	widgetId = randomWidgetId();
	settings.query = {
		"version":"1.1",
		"operation":"searchRetrieve",
		"maximumRecords":10,
		"recordSchema":"info:srw/schema/1/migranten",
		"recordPacking":"xml"
//		"sortkey":[
//			{"field":"Any","sortType":"asc"}
//		]
	};
	settings.configInfo = {
		"interfieldoperator":"and",
        "relation":"all",
        "allQuery":{"index":"iisg.collectionName", "relation":"exact","actualTerm":"migranten"},
        "baseUrl":"http://api.iisg.nl/solr/migranten/srw",
        "widgetId":"widget_" + widgetId,
        "formSearch":"search",
        "formResult":"result",
        "formNavigate":"navigate",
        "waitingMessage":"Query sent. One moment please...",
        "timeout":5000,
        "http.status":{
            "0":"You seem to have no connection to the internet.",
            "404":"URL of SRU server not found (HTTP 404). Please check your configuration or contact administrator.",
            "500":"Internal Server Error (HTTP 500). Please contact administrator",
            "parsererror":"Parsing the server's response failed.",
            "timeout":"Request Time out."
        },
        "noSearchAndRetrieveResponse":"There was no result...",
        "find_an_organization":"Find an organization",
        "user_selections":"Your selections",
        "separator":";",
        "searchbutton":"Search",
        //"searchEmptyOption":"-- No preference --",
        "shortlist":"shortlist",
        "lang":"nl-NL",
        "fadeIn":2000,
        "timeoutInputText":1000
	};
	settings.index = [];
	$(objData.record.recordData.explain.indexInfo.index).each(function(ix,data){
		settings.index.push(
			{
				"title":data.title,
				"map":data.map,
				"type":"text",
				"shortlist":true
			}
		);
	});
	updateJavascriptSource();
}

function updateSettings(name,value) { // update textarea containing javascript source
	if(name !== undefined && value !== undefined) {
		if (name.split('-').length == 2) { // field index settings
			var arrName = name.split('-');
			var key = arrName[0];var ix = arrName[1];
//			var [key,ix] = name.split('-');
			settings.index[ix][key] = value;
		} else { // global settings
			if (name.split('.').length == 2) { // single key-value
				if (name.split('_').length == 2) { // defines an array index
					var arrName = name.split('_');
					var name = arrName[0];var ix = arrName[1];
//					var [container,key] = name.split('.');
					var arrName = name.split('.');
					var container = arrName[0];var key = arrName[1];
					settings[container][key][ix]['field'] = value;
					settings[container][key][ix]['sortType'] = "asc";
				} else {
					var arrName = name.split('.');
					var container = arrName[0];var key = arrName[1];
//					var [container,key] = name.split('.');
					settings[container][key] = value;
				}
			} else { // multidimensional key-value
				var arrName = name.split('.');
				var container = arrName[0];var subContainer = arrName[1];var key = arrName[2];
//				var [container,subContainer,key] = name.split('.');
				settings[container][subContainer][key] = value;
			}
		}
	}
	updateJavascriptSource();
}
function updateJavascriptSource() {
	$("textarea#javascriptSource").val( // use the 'Dumper' function to generate the javascript source
		"<script type='text/javascript' src='http://devsolr.iisg.nl:8080/solr/IISHwidget.js'></script>\n" +
		"<script type='text/javascript'>\nvar settings = " + Dumper(settings) + "\n</script>\n" +
		"<div id='" + settings.configInfo.widgetId + "'></div>"
	);
	// a slightly dirty hack to re-render the widget demo each time \/
	$("#widgetDemo").html("<div class='iish' id='widget_" + widgetId + "'></div>");
	init();
	RenderLabels();

	runQuery(setDefaultQuery());
}

// We should return the prefered schema.
// If not available, return the cql schema
// Again, if not available, return the first schema in the index.
function indexSet(obj)// one of the indexInfo.index
{
	var set = null ;
	var schema = null ;
	var cql = null ;
	var alt = null ;

	$.each(obj.map, function(ix,obj)
		   {
		   set = ( obj['@set'])
		   ? obj['@set']
		   : obj.name['@set'] ;

		   alt = ( obj['$'] )
		   ? obj['$']
		   : obj.name['$'];

		   if ( contextSet==set )
		   {
		   schema = alt;
		   return false ;
		   }
		   else if ( set=='cql' )
		   cql = alt;
		   });

	if ( schema != null )
		return set + ":" + schema ;

	if ( cql != null )
		return set + ":" + cql ;

	return set + ":" + alt ;
}

