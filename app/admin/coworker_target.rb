ActiveAdmin.register Work::CoworkerTarget, as: "Coworker Target" do
  menu parent: "Schedule", priority: 2
  permit_params :work_unit_id, :coworker_id, :hours_per_day, :period

  form do |f|
    f.inputs do
      f.input :work_unit
      f.input :coworker
      f.input :hours_per_day
      f.input :period
    end
    f.actions
  end

  index do
    column :work_unit
    column :coworker
    column :period
    column 'avg Daily', :hours_per_day
    column 'Total Hours', :cache_of_total_hours

    actions
  end

  filter :work_unit
  filter :coworker
end
