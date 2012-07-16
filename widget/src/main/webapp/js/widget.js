var baseUrl = "http://localhost:8080/";
document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/jquery-1.4.1.min.js"></script>'));
if (typeof settings === 'undefined') {
    document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/settings.', recordSchema, '.js"></script>'));
}
document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/widget.table.js"></script>'));
document.write('<div class="iish_widget"></div>');

function startup() {
    if (typeof $ === 'undefined') {
    } else {
        window.clearInterval(_startup);
        $(document).ready(function() {
            loadWidget();
        });
    }
}
var _startup = window.setInterval(startup, 500);