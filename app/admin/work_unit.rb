ActiveAdmin.register Work::Unit do
  menu parent: "Work Unit's", priority: 5
  permit_params :name

  collection_action :autocomplete_work_unit, :method => :get

  controller do
    def autocomplete_work_unit
      render json: Work::UnitForAutocompleter.find(params[:term]),
             each_serializer: WorkUnitAutocompleterSerializer,
             root: false
    end

    def scoped_collection
      Work::Unit.where(type: nil)
    end
  end

  form do |f|
    f.inputs do
      f.input :name, as: :string
    end

    f.actions
  end
end
