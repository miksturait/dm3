ActiveAdmin.register Phase do
  menu parent: "Work Unit's", priority: 4
  permit_params :name, :parent_id, :period

  form do |f|
    f.inputs do
      f.input :name
      f.input :parent_id, as: :string,  input_html: { class: 'autocompleter_work_unit' }
      f.input :period
    end

    f.actions
  end
end
