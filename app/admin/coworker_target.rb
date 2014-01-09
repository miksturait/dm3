ActiveAdmin.register Work::CoworkerTarget, as: "Target" do
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
end
