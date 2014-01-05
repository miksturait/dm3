$ ->
  work_unit = $('select[id*="_work_unit_id"]').first()
  field_id = work_unit.attr('id')
  field_name = work_unit.attr('name')
  field_value = work_unit.attr('value')

  autocompleter = $('<input>')
  autocompleter.attr('id', field_id)
  autocompleter.attr('name', field_name)
  autocompleter.attr('value', field_value)
  autocompleter.attr('type', 'string')

  work_unit.replaceWith(autocompleter)

  autocompleter.select2
    placeholder: "Search for a Work Unit"
    minimumInputLength: 3
    ajax:
      url: "/admin/work_units/autocomplete_work_unit",
      dataType: 'json'
      data: (term, page) ->
        return(term: term)
      results: (data, page) ->
        return(results: data)
