var baseUrl = (baseUrl === undefined ) ? "//localhost:8080/" : baseUrl ;
document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/jquery-1.4.1.min.js"></script>'));
if (typeof settings === 'undefined') {
    document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/settings.', recordSchema, '.js"></script>'));
}
document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/widget.tree.js"></script>'));

//document.write('<link type="text/css" rel="Stylesheet" href="'.concat(baseUrl, 'widget/css/responseCss.css" />'));
document.write('<link type="text/css" rel="Stylesheet" href="'.concat(baseUrl, 'widget/css/menuCss.css" />'));
document.write('<div class="iish_widget"></div>');

var patience = 0;
function startup() {
    if (typeof $ === 'undefined') {
        if (patience++ > 20) {
            document.location.reload(true);
        }
    } else {
        window.clearInterval(_startup);
        $(document).ready(function() {
            loadWidget();
        });
    }
}
var _startup = window.setInterval(startup, 500);
