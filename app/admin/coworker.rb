ActiveAdmin.register Coworker do
  menu parent: "Schedule", priority: 1
  permit_params :email, :name
end
