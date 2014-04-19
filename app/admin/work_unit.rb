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


  index do
    column 'Parent' do |work_unit|
      if work_unit.parent
        work_unit.parent.name
      else
        "none"
      end
    end
    column :name
    column :wuid
    column :period
    column :opts

    actions
  end

  filter :name
  filter :wuid
end
