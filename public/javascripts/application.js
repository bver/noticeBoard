  $(document).ready(function() {
    $('ul.sf-menu').superfish();

    if( typeof specificInit == 'function'  )
        specificInit();
  });