$(document).ready(function() {
    $('ul.sf-menu').superfish();

    $( '#accordion' ).accordion({
             icons: false,
             collapsible: true,
             fillSpace:  false,
             clearStyle: true
    });

    $( '#addButton' ).button({
	    icons: { primary: 'ui-icon-star'}
    });

    if( typeof specificInit == 'function'  )
       specificInit();
});