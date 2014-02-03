ActiveAdmin.register Work::TimeEntry do
  menu parent: "Work Unit's", priority: 6

  index do
    column :label
    column :comment
    column 'coworker' do |time_entry|
      time_entry.coworker.name
    end
    column 'start at' do |time_entry|
      time_entry.period.begin.to_s(:short)
    end
    column :duration
    default_actions
  end

  controller do
    def scoped_collection
      Work::TimeEntry.includes([:work_unit, :coworker])
    end
  end

  form do |f|
    f.inputs do
      f.input :work_unit_id, as: :string, input_html: {class: 'autocompleter_work_unit'}
    end

    f.actions
  end

end
