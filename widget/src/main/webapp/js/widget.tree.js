// "global" variables
// The main div container
var divWidgetContainer = null;

function loadWidget() {
    if (!divWidgetContainer) {
        divWidgetContainer = $(".iish_widget");
    }

    // Dit voor de default tree met negen major items
    populate_tree('hisco', divWidgetContainer);
    //
    // Dan klikken op de derde major item opent de minor lijst:
//    populate_tree("hisco:3");
    //
    // Dan de eerste item in de minor opent een unit lijstje:
//    populate_tree("hisco:3:2");
    //
    // En tot slot de tweede item in de unit opent een micro lijstje:
    //populate_tree("hisco:3:2:2");


}


function populate_tree(group_id, target) {
    if (group_id == undefined || !group_id) group_id = 'hisco';
//	divWidgetSearchResultsContainer.html('');
//    var target = divWidgetContainer;
//    target.html('');
//    target.children().hide();
    var query = 'query=iisg.collectionName exact "hisco" and hisco.group_id exact "' + group_id + '"&version=1.1&operation=searchRetrieve&maximumRecords=10&recordSchema=info:srw/schema/1/hisco&recordPacking=string&startRecord=1&shortlist=';
    $.ajax({
        url:"http://localhost:8080/solr/hisco/srw",
        data:query,
        success:function (data) {

            var tree = $('<ul id="' + group_id + '">');
//            target.append('<ul id="' + group_id + '">');
            target.append(tree);

            $(data.searchRetrieveResponse.records.record).each(function (ix, record) {
                var recordData = record.recordData;


                var extraRecordData = record.extraRecordData.extraData;

                var identifier = extraRecordData.Identifier;
                var identifierNoColon = identifier.replace(/[:]/g, "");

                tree.append('<li id=' + identifierNoColon + '></li>');

                var title = $(recordData).find("dt:contains('Title')").next() ;
                var description = $(recordData).find("dt:contains('Description')").next();

                $('#' + identifierNoColon).addClass('contentContainer').html(title);
                $('#' + identifierNoColon).append(description);

                $('#' + identifierNoColon).css({'background-image':'url(' + baseUrl + 'widget/css/right.png)',
                    'background-repeat':'no-repeat',
                    'background-position':'-3px 6px'
                });

                addMenuEvent($('#' + identifierNoColon), identifier);


            });

            target.append('</ul>');


        }, dataType:"jsonp"
    });
}

function addMenuEvent(li, identifier) {
    li.toggle(
        function () { // START FIRST CLICK FUNCTION


            if ($(this).hasClass('contentContainer')) {

                //jquery call to populate submenu:
                populate_tree(identifier, li);

                $(this).children('ul').slideDown()
                $(this).removeClass('contentContainer').addClass('contentViewing');
                $(this).css({'background-image':'url(' + baseUrl + 'widget/css/down.png)',
                    'background-repeat':'no-repeat',
                    'background-position':'-4px 6px',
                    'background-color': 'transparent'

                });
            }
        }, // END FIRST CLICK FUNCTION
        function () { // START SECOND CLICK FUNCTION


            if ($(this).hasClass('contentViewing')) {

                $(this).children('ul').slideUp().remove();
//                $(this).children('dl').show();

                $(this).removeClass('contentViewing').addClass('contentContainer');
                $(this).css({'background-image':'url(' + baseUrl + 'widget/css/right.png)',
                    'background-repeat':'no-repeat',
                    'background-position':'-3px 6px'
                });


            }


        } // END SECOND CLICK FUNCTIOn
    ); // END TOGGLE FUNCTION
}


function RenderLabels_tree() {
    $.each(settings.configInfo, function (ix, obj) {
        var element = $("#" + getId(ix));
        if (element)
            element.attr('value', obj);
    })
}

function getUrl(path) {
    var url = baseUrl.concat(path);
    return url;
}
