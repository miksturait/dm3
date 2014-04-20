class Dm2::DashboardController < Dm2::ApiController
  def workload_import
    render json: import_object.process,
           serializer: DM2Import::Serializer,
           root: false
  end

  def statistics
    render json: statistics_object.summary,
           root: false
  end

  private

  def statistics_object
    @statistcs_object ||=
        Work::UserStatistics.new(params[:statistics])
  end

  def import_object
    @import_object ||=
        DM2Import::Workload.new(params[:import])
  end
end
