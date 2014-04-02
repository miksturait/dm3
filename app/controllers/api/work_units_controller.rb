class Api::WorkUnitsController < Api::ApplicationController
  def index
    respond_with collection
  end

  private

  def collection
    Work::Unit.order(:id).to_json(root: false)
  end
end
