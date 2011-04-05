  $(document).ready(function() {

    $( "#accordion" ).accordion({ icons: false });

    $('ul.sf-menu').superfish();

    $("#leftIconButton").button({
	icons: { primary: 'ui-icon-star'}
    });

  });