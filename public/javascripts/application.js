$(document).ready(function() {
    $('ul.sf-menu').superfish();

    $( '#accordion' ).accordion({
             icons: true,
             collapsible: true
             //clearStyle: true
    });

    $( '#addButton' ).button({
	    icons: { primary: 'ui-icon-star'}
    });

    if( typeof specificInit == 'function'  )
       specificInit();
});