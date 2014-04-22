update_hours_worked = ->
  start_date = $(".daterangepicker.start").val()
  end_date = $(".daterangepicker.end").val()
  hours_per_day = $("#company_project_target_hours_per_day").val()
  if (start_date && end_date && hours_per_day)
    $.ajax(
      {
        url: '/admin/company_project_targets/calculate_working_hours',
        data: {hours_per_day: hours_per_day, start: start_date, end: end_date}
        success: (data) ->
          $("#company_project_target_period_input > label:nth-child(1)").html(data['total_hours'])
      }
    )

$ ->
  $("input#company_project_target_hours_per_day").keyup( ->
      update_hours_worked()
    )
  $(".daterangepicker").datepicker
    defaultDate: "<%= Date.now.strftime('%Y-%m-%d') %>"
    dateFormat: "yy-mm-dd"
    changeMonth: true
    numberOfMonths: 1
    showOn: "button"
    showButtonPanel: true
    onClose: (selectedDate) ->
      # set the boundry on the other side
      $(this).siblings('.end').datepicker("option", "minDate", selectedDate)
      $(this).siblings('.start').datepicker("option", "maxDate", selectedDate)
      # set value of desired field
      parent = $(this).parent()
      start_date = parent.children(".daterangepicker.start").val()
      end_date = parent.children(".daterangepicker.end").val()
      range_field = parent.children('input').not('.daterangepicker')
      range_field.val "[" + start_date + ", " + end_date + "]"
      update_hours_worked()



