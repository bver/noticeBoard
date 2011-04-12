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

function bindSelects() {
   $('.nbselect').unbind('change')
   .change(function() {
      $.post("/notes/" + $(this).attr('data-id') + '.js',
         {
             _method: 'put',
             add: $(this).attr('data-add'),
             value:  $(this).attr('value')
         }
      );
   });
}
