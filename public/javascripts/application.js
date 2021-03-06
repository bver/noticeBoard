$(document).ready(function() {
    $('ul.sf-menu').superfish();

    $( '#accordion' ).accordion({
             icons: false,
             collapsible: true,
             fillSpace:  false,
             clearStyle: true
             //active: false
    });

    $( '#addButton' ).button({
	    icons: {primary: 'ui-icon-star'}
    });

    if( typeof specificInit == 'function'  )
       specificInit();

   $('body').ajaxError( function(event, jqXHR, ajaxSettings, thrownError){
       if( jqXHR.status == 0 )
          alert( "Error: Cannot connect to the server." );
       else
          alert( 'Error: ' + jqXHR.status + ': ' + thrownError + "\n" + jqXHR.responseText.substr(0,300) );
   });
   
});

function bindSelects() {
   $('.nbselect').unbind('change')
   .change(function() {
      $.post("/notes/" + $(this).attr('data-id'),
         {
             _method: 'put',
             add: $(this).attr('data-add'),
             last: $(this).attr('data-last'),
             value:  $(this).attr('value')
         }
      );
   });
}
