ActiveAdmin.register Work::CoworkerTarget, as: "Target" do
  menu parent: "Schedule", priority: 2
  permit_params :work_unit_id, :coworker_id, :hours_per_day, :period
end
