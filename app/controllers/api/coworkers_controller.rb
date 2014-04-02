class Api::CoworkersController < Api::ApplicationController
  def index
    respond_with collection
  end

  private

  def collection
    Coworker.order(:id).to_json(root: false)
  end
end
