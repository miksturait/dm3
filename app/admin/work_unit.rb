ActiveAdmin.register Work::Unit do
  menu parent: "Work Unit's", priority: 5

  controller do
    def scoped_collection
      Work::Unit.where(type: nil)
    end
  end
end
