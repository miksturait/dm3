class Dm2::ApiController < ApplicationController
  before_action :authenticate!
  skip_before_action :verify_authenticity_token

  private

  def authenticate!
    if params[:auth_token] != ENV["DM2_AUTH_TOKEN"]
      render json: {errors: 'authentication error'}, status: 401
      false
    end
  end
end
