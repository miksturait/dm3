class Dm2::ApiController < ApplicationController
  before_action :authenticate!
  skip_before_action :verify_authenticity_token

  def workload_import
    render json: import_object.process,
           serializer: DM2Import::Serializer,
           root: false
  end

  def statistics
    render json: statistics_object.summary,
           root: false
  end

  def summary
    render json: summary_object.data,
           root: false
  end

  def work_units
    render json: Dm2::UnitForAutocompleter.find(params[:term]),
           each_serializer: WorkUnitAutocompleterSerializer,
           root: false
  end


  private

  def summary_object
    @summary_object ||=
        Work::SummaryDataForTree.new(params[:q])
  end

  def statistics_object
    @statistcs_object ||=
        Work::UserStatistics.new(params[:statistics])
  end

  def import_object
    @import_object ||=
        DM2Import::Workload.new(params[:import])
  end

  def authenticate!
    if params[:auth_token] != ENV["DM2_AUTH_TOKEN"]
      render json: {errors: 'authentication error'}, status: 401
      false
    end
  end
end
