ActiveAdmin.register Customer do
  menu parent: "Work Unit's", priority: 2

  index do
    column :name
    column :opts

    actions
  end

  filter :name
end
