ActiveAdmin.register Work::UnitTarget, as: "Company/Project Target" do
  menu parent: "Finance"
  permit_params :work_unit_id, :invoice_id, :hours_per_day, :period

  form do |f|
    f.inputs do
      f.input :work_unit
      f.input :hours_per_day
      f.input :period
      f.input :invoice, as: :select2
    end
    f.actions
  end

  index do
    column :work_unit
    column :invoice
    column :period
    column 'Hours Booked', :cache_of_total_hours

    actions
  end

  filter :work_unit

  collection_action :calculate_working_hours, method: :get do
    render json: {total_hours: calculating_working_hours_object.working_hours}
  end

  controller do
    private_methods

    def calculating_working_hours_object
      Work::CalculateWorkingHours.new(period, nil, params[:hours_per_day].to_i)
    end

    def period
      Range.new(Date.parse(params[:start]), Date.parse(params[:end]))
    end

  end
end
