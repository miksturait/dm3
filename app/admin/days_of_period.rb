ActiveAdmin.register Work::DaysOffPeriod, as: "Days Off" do
  menu parent: "Schedule", priority: 4
  permit_params :coworker_id, :comment, :period
end
