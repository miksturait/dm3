class Dm2::TimeController < Dm2::ApiController

  def summary
    render json: summary_object.data,
           root: false
  end

  private

  def summary_object
    @summary_object ||=
        Work::SummaryDataForTree.new(params[:q])
  end
end
