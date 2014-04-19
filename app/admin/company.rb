ActiveAdmin.register Company do
  menu parent: "Work Unit's", priority: 1
  config.filters = false

  index do
    column :name
    column :opts

    actions
  end
end
