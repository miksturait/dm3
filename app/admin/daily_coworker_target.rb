ActiveAdmin.register Work::DailyCoworkerTarget, as: "Daily Target" do
  menu parent: "Schedule", priority: 3

  index do
    column :work_unit
    column :coworker
    column :day
    column :hours

    actions
  end

  filter :work_unit
  filter :coworker
  filter :day
end
