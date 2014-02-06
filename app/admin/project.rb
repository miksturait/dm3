ActiveAdmin.register Project do
  menu parent: "Work Unit's", priority: 3
  permit_params :wuid, :name, :opts

  form do |f|
    f.inputs do
      f.input :wuid, as: :string
      f.input :name, as: :string
      f.input :opts, as: :string
    end

    f.actions
  end

end
