class Dm2::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def workload_import
    render json: import_object.process,
           serializer: DM2Import::Serializer,
           root: false
  end


  private

  def import_object
    @import_object ||=
        DM2Import::Workload.new(params[:import])
  end
end
