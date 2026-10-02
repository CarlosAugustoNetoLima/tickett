// The only global variable we should expose in this file
window.TiktX = {
	checkoutEmbedded: function checkoutEmbedded(config) {
		if(window.location.href.indexOf("localhost") > -1) {
			config.urlCheckout = 'http://localhost/tickets/site/checkout/';
		} else {
			config.urlCheckout = 'https://checkout.tiktx.com/';
		}
		if ( config.ref === undefined || config.ref === null ) {
			config.ref = '';
		}
		if ( config.sid === undefined || config.sid === null ) {
			config.sid = '';
		}
		if ( config.language === undefined || config.language === null ) {
			config.language = 'pt_br';
		}
		htmlInsertIframe = htmlIframe(config);
		document.getElementById(config.containerId).innerHTML = htmlInsertIframe;
	}
};


function htmlIframe(config) {
	var html = '<div id="TiktxIframeLoading" style="opacity:0.5;text-align:center;vertical-align:middle;min-height: 200px;"><img src="' + config.urlCheckout + 'img/loading-spinner.gif" /></div>';
	html += '<iframe src="' + config.urlCheckout + 't' + config.embeddedId + '?event=' + config.eventId + '&sid=' + config.sid + '&l=' + config.language + '&ref=' + config.ref + '"  frameborder="0" scrolling="no" id="TiktX_Embedded_Checkout" width="100%" style="min-height: 400px;display: none" onload="document.getElementById(\'TiktxIframeLoading\').style.display=\'none\';document.getElementById(\'TiktX_Embedded_Checkout\').style.display=\'block\';"></iframe>';
	return html;
}


window.addEventListener("message", receiveMessage, false);
function receiveMessage(evt) {
	var h = evt.data;
	document.getElementById("TiktX_Embedded_Checkout").style.height = (h + 20) + 'px';
};