ActiveAdmin.register Work::CoworkerTarget, as: "Target" do
  menu parent: "Schedule", priority: 2
  permit_params :work_unit_id, :coworker_id, :hours_per_day, :period

  form do |f|
    f.inputs do
      %w(work_unit coworker period).each do |permit_param|
        f.input permit_param
      end
    end
    f.actions
  end
end
