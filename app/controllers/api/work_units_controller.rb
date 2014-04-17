class Api::WorkUnitsController < Api::ApplicationController
  def index
    respond_with collection
  end

  private

  def collection
    scope = Work::Unit.order(:id)
    if work_unit_params[:parent_work_unit_id].present?
      parent = Work::Unit.find(work_unit_params[:parent_work_unit_id])
      scope = scope.children_of(parent)
    end
    scope = scope.less_or_equal_depth(work_unit_params[:depth]) if work_unit_params[:depth].present?
    scope.to_json(
      root: false,
      only: [
        :id,
        :wuid,
        :name,
        :ancestry,
        :type,
        :created_at,
        :updated_at,
        :period,
        :opts,
        :ancestry_depth
      ]
    )
  end

  def work_unit_params
    @work_unit_params ||= params.permit(:parent_work_unit_id, :depth)
  end
end
