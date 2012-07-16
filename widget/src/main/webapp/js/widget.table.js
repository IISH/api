// "global" variables
// The main div container
var divWidgetContainer = null ;

// div for the search options
var formSearch = null ;

// div to render the query results in
var formResult = null ;

// div to manage the user selected items in
var formNavigate = null;

var formPager = null;

var imageContainer = null ;

// Selected fields to be used as shortlist items
var shortlist = null;

// stack of the query parameters
var queryArray = null;

// Used as handler to watch for changes in the search input text fields.
var timeoutId = -1;
var startRecord = 1;
var showAllRecordsInFirstView = settings.configInfo.showAllRecordsInFirstView;

var comboWidth = -1;

function loadWidget()
{
    if ( ! divWidgetContainer )
    {
        if ( settings.configInfo.cssStylesheets )
        {
            var head = $("head");
            if ( $(head).length==0)
                head = $("body");

            $.each(settings.configInfo.cssStylesheets, function(ix, link)
            {
                var stylesheet = $('<link type="text/css" href="' + getUrl(link) + '" rel="stylesheet"/>');
                $(stylesheet).appendTo(head);
            });
        }

        divWidgetContainer = $(".iish_widget");
    }
    else
    {
        $(divWidgetContainer).slideToggle();
        formSearch = null ;
        formResult = null ;
        formNavigate = null;
        formPager = null;
        imageContainer = null;
        shortlist = null;
        queryArray = null;
        labelWidth = 100;
        comboWidth = -1;
        divWidgetContainer.empty();
        $(divWidgetContainer).slideToggle();
    }

    init();
    RenderLabels();
	runQuery(setDefaultQuery(), processResponse, beforeSend);
}

function init()
{
    formNavigate = $("<div id='".concat(settings.configInfo.formNavigate, "'/>"));
    formNavigate.addClass(settings.configInfo.cssClasses.navigate);

    formSearch = $("<div id='".concat(settings.configInfo.formSearch, "'><h4>", getLangLabel(settings.configInfo.title), "</h4></div>"));
    formSearch.addClass(settings.configInfo.cssClasses.search);

    formPager = $("<div id='pager'/>");

    var search_container = $("<div id='search_container'/>");

    if ( $.isArray(settings.configInfo.languages) )
    {
        var language_select = $("<select class='language'/>");
        $.each( settings.configInfo.languages, function(ix, language)
        {
            var option = $("<option value='".concat(language['@lang'], "'>", language['$'], "</option>"));
            if ( language['@lang'] == settings.configInfo.lang_default )
                $(option).attr("selected", "true");
            $(option).appendTo(language_select);
        });

        $(language_select).change(function()
        {
            settings.configInfo.lang_default = $(this).val();
            loadWidget();
        });

        $(language_select).appendTo(formSearch);
    }

  	formResult = $("<div id='" + settings.configInfo.formResult + "'/>");
    imageContainer = $("<div id='images' style='display:none;float:left;' />");
    imageContainer.addClass(settings.configInfo.cssClasses.images);

    shortlist = new Array();

    queryArray = new Array();

	var form = $("<form/>");
	$(form).appendTo(formSearch);

	$.each(settings.index, function(ix, index)
		   {
		   if ( ! index.map || ! index.map.name )
		    return ;

           var p = $("<p><label>&nbsp;</label></p>");
		   var context = index.map.name['@set'] + "." + index.map.name['$'];
           $(p).attr("id", context);
            var displayLabel = getLangLabel(index.title);

		   switch (index['type'])
		   {
		   default:
		   case 'hidden':
		   p = null ;
		   break;

		   case 'text':

           $(p).find("label").text(displayLabel);
           $(getText(displayLabel, context, "=")).appendTo(p);

		   break;

		   case 'select':
		   var select = $("<select title='" + displayLabel + "' name='" + context + "' />");
		   select.change(function()
						 {
						 var query = setQuery(displayLabel, this.name, "exact", $(this).val(), null);
						 runQuery(query, processResponse, beforeSend);
						 });
		   $(select).appendTo(p);
		   break;
		   }

		   if ( p )
		    $(p).appendTo(form);

		   // We add items to the shortlist here.
		   // The items in the shortlist will be rendered first of all.
		   if ( index.shortlist && index.shortlist == true )
		   {
		   var title = getLangLabel(index.title) ;
		   var item = { "index":index.map.name['$'], "context": context, "title": title};
		   shortlist.push(item);
		   }
		   }
		   );

    // Div width distribution:
    var width = $(divWidgetContainer).width();
    var nom = settings.configInfo.containerlayoutratio.search + settings.configInfo.containerlayoutratio.result;
    var left_div = Math.round(width * settings.configInfo.containerlayoutratio.search/(nom));
    var right_div = Math.round(width * settings.configInfo.containerlayoutratio.result/(nom))-25;
    $(search_container).width(left_div);
    $(formResult).width(right_div);
    $(imageContainer).width(left_div-30);
    
    if ( embed )
    {
        $(formResult).css("float", "left");
        $(formResult).css("margin", "0px");

        $(imageContainer).css("float", "right");
        $(imageContainer).css("margin", "0px");

        formNavigate = null;
        formSearch = null;
        formPager = null;
        search_container = null;
    }
    else
    {
        formNavigate.appendTo(divWidgetContainer);
        formSearch.appendTo(search_container);
        formPager.appendTo(search_container);
        search_container.appendTo(divWidgetContainer);
    }
	formResult.appendTo(divWidgetContainer);
    $(imageContainer).appendTo(divWidgetContainer);
}

function setBrand(element)
{
        var branding = $("<ul class='brand'/>");
        $(branding).addClass(settings.configInfo.cssClasses.pager);
        $("<li><a href='http://www.iisg.nl/' target='_blank'>An IISH widget</a></li>").appendTo(branding);
        $(branding).appendTo(element);
}

function getLangLabel(index)
{
    if ( ! index )
        return "";

    if ( !$.isArray(index ) )
        return index;

    if ( settings.configInfo.lang_default )
    {
        var label = null;
        $.each(index,  function(ix, title)
        {
            if ( settings.configInfo.lang_default==title['@lang'] )
            {
                label = title['$'];
                return;
            }
        });

        if ( label )
            return label;
    }

	return index[0]['$'];
}

function getId(text)
{
	return settings.configInfo.widgetId + text;
}

function getText(displayLabel, index, relation)
{
	var input = $("<input name='" + index + "' type='text'/>");

	$(input).keyup(function()
				   {
				   clearTimeout(timeoutId);
				   var funct = "setTimer(this, '".concat(displayLabel, "', '",index, "', '", relation, "','", $(this).val(), "');");
				   timeoutId  = setTimeout(funct, settings.configInfo.timeoutInputText);
				   });

	return input;
}

function setTimer(obj, displayLabel, index, relation, value)
{
	var query = setQuery(displayLabel, index, relation, value, null);
	runQuery(query, processResponse, beforeSend);
};

function beforeSend()
{
    $(formResult).html("<p class=\"waiting\">".concat(getLangLabel( settings.configInfo.waitingMessage ), "</p>"));
}

function runQuery(query, callback, friendlyMessage)
{
//	console.debug(query);
	$.ajax({
		   type: "GET",
		   url: getUrl(getLangLabel(settings.configInfo.baseUrl)),
		   data: query,
		   beforeSend: friendlyMessage,
		   success: function(data)
		   {
		   SearchInputElements(true);
		   window.setTimeout("SearchInputElements(false)", 10000); // Just to make sure we do not lock all permanently.
		   callback(data);
		   SearchInputElements(false);
		   },
		   timeout: settings.configInfo.timeout,
		   error:function(x,e){
		   var friendly_message = settings.configInfo['http.status'][status];
		   if ( ! friendly_message )
		   friendly_message = x.responseText ;

		   $(formResult).html(friendly_message);
		   }
		   ,

		   dataType: "jsonp"
		   });

	window.scrollTo(0, $(divWidgetContainer).top);
}

// When a user selection, we freeze the controls to prevent user-select-overload.
// After a response and re-rendering, the controls are enabled again.
function SearchInputElements(disable)
{
	if ( disable )
	{
		$(divWidgetContainer).find("input").attr("disabled", "true") ;
		$(divWidgetContainer).find("select").attr("disabled", "true");
	}
	else
	{
		$(divWidgetContainer).find("input").removeAttr("disabled") ;
		$(divWidgetContainer).find("select").removeAttr("disabled") ;
	}
}

// Sets the default for the query parameter of the SRU request.
// The purpose of this is to cover: a.all records in the database; or b. point to a single record.
function setDefaultQuery()
{
    showAllRecordsInFirstView = (embed)
        ? true
        : settings.configInfo.showAllRecordsInFirstView ;

    var query = ( embed )
        ? setQuery(null, settings.configInfo.embedQuery.index, settings.configInfo.embedQuery.relation, embed, null)
        : setQuery(null, settings.configInfo.allQuery.index, settings.configInfo.allQuery.relation, settings.configInfo.allQuery.actualTerm, null);

	// remove the default query
	removeSearchItem(settings.configInfo.allQuery.index);

	return query ;
}

// Sets the query parameter of the SRU request
function setQuery(displayLabel, index, relation, value, interfieldoperator)
{
	if ( index )
		addSearchItem(displayLabel, index, relation, value, interfieldoperator);

	var query = getRequestQuery();

	return query ;
}

function addSearchItem(displayLabel, index, relation, actualTerm, interfieldoperator)
{
	if ( !relation)
		relation = settings.configInfo.relation;

	if ( !interfieldoperator)
		interfieldoperator = settings.configInfo.interfieldoperator ;

	removeSearchItem(index);

	if ( $.trim(actualTerm).length != 0 )
	{
		var searchComponent = {"displayLabel":displayLabel, "index":index, "relation":relation, "actualTerm":"\"".concat(encodeURIComponent(actualTerm), "\""), "displayTerm":actualTerm, "interfieldoperator":interfieldoperator };
		queryArray.push(searchComponent);
	}
}

function removeSearchItem(index)
{
	var arr = $.grep(queryArray, function(value)
					 {
					 return value.index != index;
					 });

	queryArray = arr;
}

// Add records to shortlist
function processResponse(data)
{
	if ( !data.searchRetrieveResponse || !data.searchRetrieveResponse.records)
	{
		$(formResult).html("<p>" + settings.configInfo.noSearchAndRetrieveResponse + "</p>");
        setBrand(formResult);
		return ;
	}

     if ( !showAllRecordsInFirstView )
    {
        showAllRecordsInFirstView = true ;
        $(formNavigate).hide();
        $(formResult).hide();
        setDropdownFacetLists(data);
        setBrand(formResult);
        return ;
    }

    if ( embed )
        setResultset(data);
    else
    {
        setResultset(data);
	    setNavigation(data);
	    setDropdownFacetLists(data);
        setPager(data);
        setCarousel({wrap:'circular',size:5});
    }

}

function setCarousel(args)
{
    if ( $.jcarousel )
        $(".jcarousel-skin-tango").jcarousel(args);

    var imgs = $(".jcarousel-skin-tango").find("img").click(function()
    {
        $(imageContainer).empty();
        $(imageContainer).hide();
        var img = $(this).clone();
        $(img).removeAttr("height");
        $(img).removeAttr("width");
        $(img).appendTo(imageContainer);
        $(imageContainer).fadeIn();
    });
}

function setPager(data)
{
    formPager.empty();

    var pagerAsHtml = getPager(data.searchRetrieveResponse.numberOfRecords, data.searchRetrieveResponse.echoedSearchRetrieveRequest.startRecord, data.searchRetrieveResponse.nextRecordPosition, data.searchRetrieveResponse.echoedSearchRetrieveRequest.maximumRecords);
	if ( pagerAsHtml != null )
		$(pagerAsHtml).appendTo(formPager);
}

// Create the shortlist of the resultset.
// The items of the shortlist are clickable: click leads to opening of all details.
function setResultset(data)
{
	// Select the array of indices that were selected previously .
	// We do not want to offer query links to these indices again...
	var selected_indices = new Array();
	$.each(queryArray, function(ix, obj)
		   {
		   selected_indices.push(obj.index);
		   });

    var ol = $("<ol style='display:none'/>");
    var ol_class = ( embed )
        ? settings.configInfo.cssClasses.embededresultset
        : settings.configInfo.cssClasses.resultset;
    $(ol).addClass(ol_class);
    $(ol).css("counter-reset","item " + String(data.searchRetrieveResponse.echoedSearchRetrieveRequest.startRecord-1));

    if ( $.isArray(data.searchRetrieveResponse.records.record) )
        $.each(data.searchRetrieveResponse.records.record, function(ix, record)
		   {
               var Identifier = ( record.extraRecordData.extraData.Identifier )
                ? record.extraRecordData.extraData.Identifier
                       : null;
               var li = getRecordData(Identifier, record.recordData, data.searchRetrieveResponse.numberOfRecords);
               if ( li )
                $(li).appendTo(ol);
           })
else
{
    var Identifier = ( data.searchRetrieveResponse.records.record.extraRecordData.extraData.Identifier )
                ? data.searchRetrieveResponse.records.record.extraRecordData.extraData.Identifier
                : null;
        var li = $(getRecordData(Identifier, data.searchRetrieveResponse.records.record.recordData)).appendTo(ol);
               if ( li )
                $(li).appendTo(ol);
            }

    // Set the dt and dd relative widths
    // dd, dt distributions
    var container_width = $(formResult).width()-60;
    var nom = settings.configInfo.resultslayoutratio.dt + settings.configInfo.resultslayoutratio.dd;
    var dt_width = Math.round(container_width * settings.configInfo.resultslayoutratio.dt / nom);
    var dd_width = Math.round(container_width * settings.configInfo.resultslayoutratio.dd / nom);
    $(ol).find("dt").width(dt_width);
    $(ol).find("dt").css("clear","both");
    $(ol).find("dd").width(dd_width);
    $(ol).find("dd").css("float","left");
    $(ol).find("dl").width(container_width+40);

	$(formResult).empty();
	$(ol).appendTo(formResult);
	$(ol).fadeIn(settings.configInfo.fadeIn);

    formResult.show();

        setBrand(formResult);
}

function carousel(dt, dd_images) {
    {
        $(dt).hide();
        var ol_carousel = $("<ul class='jcarousel-skin-tango'/>");
        $.each(dd_images, function(ix, dd)
        {
            var l = $("<li/>");
            var img = $(dd).find("img");
            $(img.clone()).appendTo(l);
            $(dd).remove();
            $(l).appendTo(ol_carousel);
        });
        var dd = $("<dd/>");
        $(dd).insertAfter(dt);
        $(ol_carousel).appendTo(dd);
    }
}

function pages(dt, dd_images) {
    {
        var pages = $("<ul class='metspages'/>");
        $.each(dd_images, function(ix, dd)
        {
            var l = $("<li/>");

            if ( $(dd).hasClass("label"))// assuming label comes always first
            {
                var label = dd;
                var thumbnail_url = $(dd).nextAll("dd.thumbnail:first");
                var reference_url = $(dd).nextAll("dd.reference:first");

                var img_thumbnail = $("<img title='' alt=''/>");
                $(img_thumbnail).attr("src", $(thumbnail_url).text());
                $(img_thumbnail).appendTo(l);

                var p = "<p>" + $(label).text() + "</p>";
                $(p).appendTo(l);
                $(l).appendTo(pages);

                $(img_thumbnail).click(function()
                {
                    $(imageContainer).empty();
                    $(imageContainer).hide();
                    var reference_image = $("<img />");
                    $(reference_image).attr("width", $(imageContainer).width());
                    $(reference_image).attr("title", $(label).text());
                    $(reference_image).attr("src", $(reference_url).text());
                    $(reference_image).click(function()
                    {
                        window.open($(reference_url).text());
                        return false;
                    });

                    $(reference_image).appendTo(imageContainer);
                    $(imageContainer).fadeIn();
                });

                // Cleanup.
                $(label).remove();
                $(thumbnail_url).remove();
                $(reference_url).remove();
            }
        });

        var dd = $("<dd class='page'/>");
        $(dd).insertAfter(dt);
        $(pages).appendTo(dd);
    }
}

function getRecordData(Identifier, recordData, numberOfRecords)
{
    if ( recordData == null || recordData.diagnostic )
        return ;

    var dl_fulllist = $(recordData);
    if ( dl_fulllist.length == 0 )
        return ;

    var id = getIdentifier(Identifier);
    var li = $("<li id='".concat(id, "'/>"));
    $(dl_fulllist).addClass(settings.configInfo.cssClasses.fulllist);

    // Images, if any.
    var dt = $(dl_fulllist).find("dt").filter(':contains(images)');
    var dd_images = $(dt).nextUntil("dt");
    if ( $(dd_images).length != 0 )
        carousel(dt, dd_images);

    // used to show pages in METS
    dt = $(dl_fulllist).find("dt").filter(':contains(documents)');
    dd_images = $(dt).nextUntil("dt");
    if ( $(dd_images).length != 0 )
    {
        pages(dt, dd_images);

        var dt_pagecount = $(dl_fulllist).find("dt").filter(':contains(pages)');
        var dd_count = $(dt_pagecount).next("dd");
        var count = Number($(dd_count).text());

        if ( count > settings.query.maximumRecords )
        {
        var select = $("<select/>");
        var step = Math.round(count / settings.query.maximumRecords) + 1;
        for ( var i = 0 ; i < step ; i++)
        {
            var from = (i * settings.query.maximumRecords ) + 1;
            if ( from > count )
                break ;

            var until = from + settings.query.maximumRecords - 1;
            if ( until > count )
                until = count ;
            var text = ( from == until )
                ? from
                : from+ "-"+ until ;

            var option = $("<option/>");
            $(option).text(text);
            $(option).val(from);
            $(option).appendTo(select);
        }
            dt.empty();
            $(select).appendTo(dt);
            $(select).change(function()
            {
                settings.configInfo.metsStartRecord = $(this).val();
                var store = queryArray;
                queryArray = null ; // really neccesary ?
				queryArray = new Array();
                addSearchItem(null, settings.configInfo.embedQuery.index, settings.configInfo.embedQuery.relation, Identifier, null);
                var query = getRequestQuery();
                runQuery(query, processResponsePages, null);

                // cleanup
                settings.configInfo.metsStartRecord = null;
                queryArray = store;
            });
        }
    }

    // Now the fulllist labels
    dt = dl_fulllist.find("dt.label");
    for ( var i = 0 ; i < dt.length ; i++)
    {
        makeFullList(dt[i]);
    }

    if ( Identifier != null )
    {

        var emb = $('<button style="float:right">embed</button>');
        $(emb).addClass(settings.configInfo.cssClasses.embed);
        $(emb).click(function()
        {
            var input = $(this).parent().parent().find("textarea");
            if ( $(input).length == 0 )
            {
                input = $('<dd><textarea style="width:300px;font-size:smaller;"><script type="text/javascript">\nvar embed="'+Identifier+'";\nvar recordSchema="'+recordSchema+'";\n</script>\n<script type="text/javascript" src="' + getUrl(settings.configInfo.embedparameters.url) + '"/></textarea></dd>');
                $(input).insertBefore(dd);
                $(input).click(function()
                {
                    $(this).find("textarea").focus();
                    $(this).find("textarea").select();
                    return false;
                });
            }
            else
                $(input).parent().remove();

            return false ;
        });

        var source = $('&x32;<button style="float:right">view source</button>');
        $(source).addClass(settings.configInfo.cssClasses.embed);
        $(source).click(function()
        {
            var reference_url = getUrl(getLangLabel(settings.configInfo.baseUrl)).concat("?query=",settings.configInfo.embedQuery.index, " ", settings.configInfo.embedQuery.relation, " ", Identifier, "&recordSchema=", settings.query.recordSchema, "&version=", settings.query.version, "&operation=", settings.query.operation, "&recordPacking=xml", "&stylesheet=");
            window.open(reference_url);
            return false;
        });
        
    var dl = $(dl_fulllist).find("dt:first");
    dt = $("<dt class='label'>Actions</dt>");
    $(dt).insertBefore(dl);
    var dd = $("<dd/>");
    $(dd).insertAfter(dt);
        $(source).appendTo(dd);
    $(emb).appendTo(dd);
    }

    // Show a shortlist, but only if there are any fields labeled as such
    // And only if we have more than one record in the resultset.
    dt = dl_fulllist.find("dt.sl");
    if ( numberOfRecords !=1 && dt.length!=0)
    {
                $(dl_fulllist).hide();
        var dl_shortlist = $("<dl/>");
        $(dl_shortlist).addClass("shortlist", settings.configInfo.cssClasses.shortlist);
        //var dl = $("<dl/>");
        //$(dl).appendTo(shortlist);

        // Filter out the shortlist items:
        $.each(dt, function()
        {
            var dt_clone = $(this).clone();
            var dt_clone = $(this).clone();
            var dd_clone = $(this).next().clone();
            $(dd_clone).removeClass("hyperlink");
            $(dt_clone).appendTo(dl_shortlist);
            $(dd_clone).appendTo(dl_shortlist);
        });

                   $(li).mouseover(function()
                   {
                       $(this).find("dl.shortlist").addClass("highlight");
                   });
                   $(li).mouseleave(function()
                   {
                       $(this).find("dl.shortlist").removeClass("highlight");
                   });

        $(li).click(function() // scroll up or down when clicked
							  {
							  $(this).find("dl.shortlist").slideToggle("normal");
							  $(this).find("dl.fulllist").slideToggle("normal");
							  });

        $(dl_shortlist).appendTo(li);
               }

$(dl_fulllist).appendTo(li);
    return li;
}

function processResponsePages(data)
{
    var dl_fulllist = $(data.searchRetrieveResponse.records.record.recordData);
    var dt_new = $(dl_fulllist).find("dt").filter(':contains(documents)');
    var dd_new_images = $(dt_new).nextUntil("dt");

    var id = getIdentifier(data.searchRetrieveResponse.records.record.extraRecordData.extraData.Identifier);
    var li = $("#"+id.replace(/(:|\.)/g,'\\$1'));

    var dt_current = $(li).find("dt.documents");
    var dd_current_images = $(dt_current).next();
    $(dd_current_images).remove();

    pages(dt_current, dd_new_images);
}

/*
The result is processes thus:
    <dl>            One dl per record.
        Labels:     <dt class="label">The value of the label</dt>
                    <dd>The value falling under label
                    <dd>etc
        Queries:    <dt>query</dt>
                    <dd class="relation">The sru relation: mostly "exact"
                    <dd class="index">The field to look in. This includes the contextSet.
                    <dd class="interfieldoperator">Depends on the settings. The getDataRow calls setQuery and overrules this value.
                    <dd class="recordSchema">Depends on the settings. The getDataRow calls setQuery and overrules this value.
                    <dd class="maximumRecords">Depends on the settings. The getDataRow calls setQuery and overrules this value.
        Images:     <dt>images</dt>
                    <dd>The url. dd can be repeated.
                    <dd>etc
        Shortlist:  <dt>shortlist</dt> If set adds the record column to the shortlist.
                    <dd>yes|no</dd> or <dd/>

                    The parameter dt contains only a list of dt[class='label']... we have to iterate to get other dt and elements.
 */
function makeFullList(dt)
{
    // Add link ?
    // The dd display element becomes clickable
    if ( $(dt).hasClass("hyperlink") )
        {
            $(dt).removeClass("hyperlink")
            var dt_sru = $(dt).nextAll("dt.sru:first"); // Liked to have used .next("dt");
            if ($(dt_sru).length!=0)
            {
            var dd_index = $(dt_sru[0]).nextAll("dd.index:first");
            var dd_relation = $(dt_sru[0]).nextAll("dd.relation:first");
            if ( dd_index.length!=0 && dd_relation.length!=0 )
            {
                var dt_displayValues = $(dt).nextUntil("dt"); // Assuming all dd follow the dt's
                $(dt_displayValues).addClass("hyperlink");
                $(dt_displayValues).click(function()
                {
                    var query = setQuery($(dt).text(), $(dd_index).text(), $(dd_relation).text(), $(this).text(), settings.configInfo.interfieldoperator );
                    runQuery(query, processResponse, beforeSend);
                });
            }
            }
        }

    return dt ;
    }

function setNavigation(data)
{
	$(formNavigate).empty();
    var header = $("<h4/>");
    $(header).text(getLangLabel(settings.configInfo.user_selections));
    $(header).appendTo(formNavigate);

	var index_record = 0 ;
	$.each(queryArray, function(ix,obj)
		   {
               index_record++;
		   var p = $("<p/>");
		   p.text(obj.displayLabel.concat(": ", obj.displayTerm));
           var span = $("<span class='ui-icon ui-icon-circle-close' />");
           $(span).prependTo(p);
		   $(p).click(function()
					   {
					   removeSearchItem(obj.index);
					   runQuery(getRequestQuery(), processResponse, beforeSend);
					   });

               $(p).mouseover(function()
               {
                   $(this).addClass("highlight");
               });
               $(p).mouseleave(function()
               {
                   $(this).removeClass("highlight");
               });

		   $(p).appendTo(formNavigate);
		   });

	if ( index_record != 0)
	{
        var p = $("<p style='font-weight:normal'/>");
		$(p).text(getLangLabel(settings.configInfo.clear_all));
		p.click(function()
				 {
				 queryArray = null ; // really neccesary ?
				 queryArray = new Array();
				 runQuery(setDefaultQuery(), processResponse, beforeSend);
				 });
		p.appendTo(header);
	}

    $(formNavigate).show();
}

function setDropdownFacetLists(data)
{
	if ( ! data.searchRetrieveResponse.extraResponseData || !data.searchRetrieveResponse.extraResponseData.extraData.facetedResults )
		return ;

    var listitems = $(formSearch).find("p");
    $.each(listitems, function()
    {
        var select = $(this).find("select");
        if ( $(select).length == 1 )
        {
            $(select).empty();
            $(this).hide();
        }
    });

	$.each(data.searchRetrieveResponse.extraResponseData.extraData.facetedResults.dataSource.facets.facet, function(ix, obj)
		   {
		   var p = $("p[id='" + obj.index + "']");
		   if ( ! p)
		   return true;

		   var select = $(p).find("select");
		   if ( select )
		   {

		   if ( obj.terms ) // there are facet categories... we cannot offer a delete parameter or present searchable items.
		   $(p).show();
		   else
		   {
		   //$(li).hide();
		   return true;
		   };

		   if ( $.isArray(obj.terms.term) )
		   $(select).removeAttr("disabled");
		   else
		   $(select).attr('disabled', true);
		   //if ( !$.isArray(obj.terms.term) ) // just one item... we can offer a delete parameter option here.
		   //{
		   //  textbox.html("<span class='title'>" + $(select).attr("title") + ":</span>" + obj.terms.term.actualTerm);
		   //textbox.show();
		   //return true ;
		   //}

		   if ( obj.terms.term.length > 1 )
		   {
		   if ( settings.configInfo.searchEmptyOption ) // We should offer a no-select option...
		   // supress our combo and show the title: value with an undo option.
		   $("<option>" + settings.configInfo.searchEmptyOption + "</option>").prependTo(select);
		   else // Show us the label
		   $("<option>" + $(select).attr("title") + "</option>").prependTo(select);
		   }
		   else
		   {
		   //var option = $("<option>" + $(select).attr("title") + "</option>");
		   //option.text(obj.terms.term.actualTerm);
		   //$(option).appendTo(select);
		   $(p).hide();
		   return;
		   }

		   // Add facet items in the combo list
		   $.each(obj.terms.term, function()
				  {
				  var option = $("<option />");
				  option.text(String(this.actualTerm).concat(" (", this.count, ")"));
				  option.val(this.actualTerm);
				  option.appendTo(select);
				  });

		   $(select).show();
		   }
		   });

    if ( comboWidth == -1 )
    {
        comboWidth = ($(formSearch).width() * 4 / 5);

    $(formSearch).find("select").width(comboWidth);
        $(formSearch).find("input").width(comboWidth - 4);
    $(formSearch).find(".language").width(100);

    // Fix for older browsers. ToDo: should use $.support but we do not know yet what the CSS issue is.
        if ( $.browser.msie && $.browser.version < 8)
        {
            var p = $(formSearch).find("p");
            $(p).width($(formSearch).width());
        }
    }
}

function getRequestQuery()
{
	var query = "query=";

	if ( queryArray.length == 0 ) // possible if all selections are removed. Fallback on the default query
		return setDefaultQuery();
	else
		$.each(queryArray, function(ix,obj)
			   {
			   query=(ix == queryArray.length - 1)
			   ? query.concat(obj.index, " ", obj.relation, " ", obj.actualTerm)
			   : query.concat(obj.index, " ", obj.relation, " ", obj.actualTerm, " ", obj.interfieldoperator, " ");
			   });

	// Add sru parameters...

	$.each(settings.query, function(ix, obj)
		   {
		   query=query.concat("&", ix, "=", obj);
		   });
	query=query.concat("&startRecord=", startRecord);

	// Add non-sru, yet client \ widget related parameters. ToDo: Put this into a .each to avoid hardcoding
    query=query.concat("&lang=", settings.configInfo.lang_default);
    if ( settings.configInfo.metsStartRecord )
        query=query.concat("&metsStartRecord=", settings.configInfo.metsStartRecord);

	return query ;
}

// Any UI labels\titles can be customised
function RenderLabels()
{
	$.each(settings.configInfo, function(ix, obj)
		   {
		   var element = $("#" + getId(ix));
		   if (element)
		   element.attr('value', obj);
		   })
}

function getPager(numberOfRecords, _startRecord, nextRecordPosition, maximumRecords){
	var maxPagingLinks = settings.configInfo.maxPagingLinks;

	if(numberOfRecords > (maxPagingLinks * parseInt(maximumRecords))){         // restrict amount of page links
		var nrPagingRecords = (maxPagingLinks * parseInt(maximumRecords));
		var endLoop = parseInt(nrPagingRecords) + parseInt(_startRecord);
	} else {
		var nrPagingRecords = numberOfRecords;
		var endLoop = numberOfRecords;
	}

	if ( nrPagingRecords == 0 )
		return null ;

	var pagerHtml = "<ol".concat(" class='", settings.configInfo.cssClasses.pager, "'><li>", numberOfRecords, " records:</li>");

	if(_startRecord != 1){     // no previous button on first page
		pagerHtml += "<a href=\"javascript:zoek(" + (_startRecord - maximumRecords) + ")\">< Prev </a>";
	}

	var k = (_startRecord < (maxPagingLinks * parseInt(maximumRecords)))    // slide list of pages to right if on 10th or greater page
	? 1
	: _startRecord - (maxPagingLinks * parseInt(maximumRecords));

	for( ; k < endLoop ; k += parseInt(maximumRecords) )
	{
		var until = ((k + parseInt(maximumRecords)) > numberOfRecords)
		? numberOfRecords
		: k + parseInt(maximumRecords);

		pagerHtml = (_startRecord == k)
		? pagerHtml.concat("<li><strong><a>[" + k + " - " + until + "]</a></strong></li>") // maak disabled link [k tot k * maximumRecords]
		: pagerHtml.concat("<li><a href=\"javascript:zoek(" + k + ")\">[" + k + " - " + until + "]</a></li>");
	}

	if((parseInt(nextRecordPosition) - parseInt(_startRecord)) == maximumRecords ) // not on last page
		pagerHtml += "<a href=\"javascript:zoek(" + nextRecordPosition + ")\"> Next ></a>";

	pagerHtml += "</ol>";

	return pagerHtml;
}

function zoek(_startRecord)
{
	startRecord = _startRecord ;
	var query = getRequestQuery();
	runQuery(query, processResponse, beforeSend);
	startRecord = 1;
}

// http://www.w3schools.com/tags/att_standard_id.asp
function getIdentifier(identifier_suffix)
{
    var identifier = "recordId_".concat(identifier_suffix);

    return identifier;
}

function getUrl(path)
{
    var url = baseUrl.concat(path);

    return url;
}