class Api::WorkEntriesController < Api::ApplicationController
  def index
    respond_with collection
  end

  private

  def collection
    scope = Work::TimeEntry.includes(:coworker).order(:id)
    scope = scope.where(coworker_id: time_entry_params[:coworker_ids]) if time_entry_params[:coworker_ids].present?
    scope = scope.work_unit_id_eq(time_entry_params[:work_unit_id]) if time_entry_params[:work_unit_id].present?
    scope = scope.after_start_time(time_entry_params[:after]) if time_entry_params[:after].present?
    scope = scope.before_start_time(time_entry_params[:before]) if time_entry_params[:before].present?
    scope.limit(100).to_json(
      root: false,
      only: [
        :id,
        :coworker_id,
        :work_unit_id,
        :duration,
        :comment,
      ],
      methods: [
        :coworker_name,
        :start_time,
        :end_time
      ]
    )
  end

  def time_entry_params
    @time_entry_params ||= params.permit(:coworker_ids, :after, :before, :work_unit_id).tap do |_params|
      _params[:coworker_ids] = Array.wrap(params[:coworker_ids])
      _params[:work_unit_id] = params[:work_unit_id].to_i.nonzero?
    end
  end
end
