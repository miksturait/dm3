ActiveAdmin.register Work::UnitTarget, as: "Company/Project Target" do
  menu parent: "Schedule"
  permit_params :work_unit_id, :hours_per_day, :period

  form do |f|
    f.inputs do
      f.input :work_unit
      f.input :hours_per_day
      f.input :period
    end
    f.actions
  end
end
