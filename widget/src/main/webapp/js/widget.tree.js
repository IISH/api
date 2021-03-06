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
    var query = 'query=iisg.collectionName exact "hisco" and hisco.group_id exact "' + group_id + '"&version=1.1&operation=searchRetrieve&maximumRecords=10&recordSchema=info:srw/schema/1/hisco&recordPacking=string&startRecord=1&shortlist=';
    $.ajax({
        url:settings.configInfo.baseUrl,
        data:query,
        success:function (data) {

            var tree = $('<ul id="' + group_id + '">');
            target.append(tree);

            $(data.searchRetrieveResponse.records.record).each(function (ix, record) {
                var recordData = record.recordData;
                var extraRecordData = record.extraRecordData.extraData;
                var identifier = extraRecordData.Identifier;
                var hisco_id = identifier.substring(6).replace(/[:]/g, "");
                var identifierNoColon = identifier.replace(/[:]/g, "");
                var listItem = $('<li id=' + identifierNoColon + '></li>');
                var group_id = $(recordData).find("dt:contains('Group identifier')").next().html().substring(6);
                var title = $(recordData).find("dt:contains('Title')").next().html();
                var description = $(recordData).find("dt:contains('Description')").next();

                tree.append(listItem);
                listItem.addClass('contentContainer');
                listItem.append('<div class="group_id">' + formatHiscoId(hisco_id) + '&nbsp;</div>');
                listItem.append('<div class="title">' + title + '</div>');
                listItem.append(description);
                description.addClass('description');

                listItem.css({'background-image':'url(' + baseUrl + 'widget/css/right.png)',
                    'background-repeat':'no-repeat',
                    'background-position':'-3px 6px'
                });

                addMenuEvent(listItem, identifier);
                var searchButton = $('<dd><a target="_blank" href="' + baseWidgetUrl + '?value=' + hisco_id + '&relation=%3D&index=hisco.group_ids">view records</a></dd>');
                searchButton.click(function (event) {
                    event.stopImmediatePropagation();
                });
                listItem.append(searchButton);
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

                $(this).children('ul').slideDown();
                $(this).removeClass('contentContainer').addClass('contentViewing');
                $(this).css({'background-image':'url(' + baseUrl + 'widget/css/down.png)',
                    'background-repeat':'no-repeat',
                    'background-position':'-4px 6px',
                    'background-color':'transparent'

                });
            }
        }, // END FIRST CLICK FUNCTION
        function () { // START SECOND CLICK FUNCTION


            if ($(this).hasClass('contentViewing')) {

                $(this).children('ul').slideUp().remove();
//                $(this).children('dl').show();

                $(this).removeClass('contentViewing').addClass('contentContainer');
                //$(this).css({'background-image':'url(' + baseUrl + 'widget/css/right.png)',
                //  'background-repeat':'no-repeat',
                //'background-position':'-3px 6px'
                //});


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

/**
 * formatHiscoId
 *
 * Formats the number into parts:x-x-x.xx
 * Example 62290
 * major: 6
 * minor: 6-2
 * unit: 6-22
 * micro: 6-22.90
 */
function formatHiscoId(id) {
    var tag = String(id);
    switch (tag.length) {
        case 1:
            return tag;
        case 2:
            return tag.substring(0, 1) + "-" + tag.substring(1, 2);
        case 3:
            return tag.substring(0, 1) + "-" + tag.substring(1, 3);
        case 5:
            return tag.substring(0, 1) + "-" + tag.substring(1, 3) + "." + tag.substring(3, 5);
        default:
            return tag;
    }
}
