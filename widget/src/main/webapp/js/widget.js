var baseUrl = "http://api.socialhistoryservices.org/";
//var baseUrl = "http://localhost:8080/";
document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/jquery-1.4.1.min.js"></script>'));
if (typeof settings === 'undefined') {
    document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/settings.', recordSchema, '.js"></script>'));
}
document.write('<script type="text/javascript" src="'.concat(baseUrl, 'widget/js/widget.table.js"></script>'));
document.write('<div class="iish_widget"></div>');

function startup() {
    if (typeof $ === 'undefined') {
    } else {

        // Taken from http://jquery-howto.blogspot.nl/2009/09/get-url-parameters-values-with-jquery.html
        $.extend({
            getUrlVars:function () {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            },
            getUrlVar:function (name) {
                return $.getUrlVars()[name];
            }
        });

        window.clearInterval(_startup);
        $(document).ready(function () {
            loadWidget();
        });
    }
}
var _startup = window.setInterval(startup, 500);
