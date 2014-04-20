$ ->
  $(".daterangepicker").datepicker
    defaultDate: "<%= Date.now.strftime('%Y-%m-%d') %>"
    dateFormat: "yy-mm-dd"
    changeMonth: true
    numberOfMonths: 1
    showOn: "button"
    showButtonPanel: true
    onClose: (selectedDate) ->
      # set the boundry on the other side
      $(this).siblings('.end').datepicker( "option", "minDate", selectedDate )
      $(this).siblings('.start').datepicker( "option", "maxDate", selectedDate )
      # set value of desired field
      parent = $(this).parent()
      start_date = parent.children(".daterangepicker.start").val()
      end_date = parent.children(".daterangepicker.end").val()
      range_field = parent.children('input').not('.daterangepicker')
      range_field.val "[" + start_date + ", " + end_date + "]"
