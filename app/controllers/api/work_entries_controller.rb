class Api::WorkEntriesController < Api::ApplicationController
  VALID_GROUP_BY_TIME_PARAMS = %w(
    day
    week
    month
  )
  VALID_GROUP_BY_PARAMS = ['coworker', *VALID_GROUP_BY_TIME_PARAMS]

  def index
    if valid_params?
      respond_with collection
    else
      head :unprocessable_entity
    end
  end

  private

  def collection
    scope = Work::TimeEntry.includes(:coworker).order(:id)
    scope = scope.where(coworker_id: time_entry_params[:coworker_ids]) if time_entry_params[:coworker_ids].present?
    scope = scope.work_unit_id_eq(time_entry_params[:work_unit_id]) if time_entry_params[:work_unit_id].present?
    scope = scope.after_start_time(time_entry_params[:after]) if time_entry_params[:after].present?
    scope = scope.before_start_time(time_entry_params[:before]) if time_entry_params[:before].present?
    if params[:page].present?
      scope = scope.page(params[:page])
      scope = scope.per(params[:limit]) if params[:limit].present?
    end

    if group_by_param_exists?
      group_time_entries(scope).to_json
    else
      scope.to_json(
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
  end

  def time_entry_params
    @time_entry_params ||= params.permit(:coworker_ids, :after, :before, :work_unit_id, :group_by).tap do |_params|
      _params[:coworker_ids] = Array.wrap(params[:coworker_ids])
      _params[:work_unit_id] = params[:work_unit_id].to_i.nonzero?
      _params[:group_by] = Array.wrap(params[:group_by])
    end
  end

  def group_time_entries(scope)
    all = {}
    scope.each do |time_entry|
      h = all
      time_entry_params[:group_by].each_with_index do |key, index|
        gk = time_entry_grouping_value(time_entry, key)
        h[gk] ||= (index == time_entry_params[:group_by].size - 1) ? [] : {}
        h = h[gk]
      end
      h << build_time_entry_hash(time_entry)
    end
    all
  end

  def time_entry_grouping_value(time_entry, key)
    case key
    when 'day'
      time_entry.start_time.beginning_of_day.iso8601
    when 'week'
      time_entry.start_time.beginning_of_week.iso8601
    when 'month'
      time_entry.start_time.beginning_of_month.iso8601
    when 'coworker'
      time_entry.coworker_id.to_s
    else
      raise 'Invalid key for grouping'
    end
  end

  def build_time_entry_hash(time_entry)
    {
      id: time_entry.id,
      coworker_id: time_entry.coworker_id,
      work_unit_id: time_entry.work_unit_id,
      duration: time_entry.duration,
      comment: time_entry.comment,
      coworker_name: time_entry.coworker_name,
      start_time: time_entry.start_time.iso8601,
      end_time: time_entry.end_time.iso8601
    }
  end

  def valid_params?
    !group_by_param_exists? || valid_group_by_params?
  end

  def valid_group_by_params?
    group_by_param_exists? &&
    group_by_param_is_not_too_deep? &&
    group_by_param_contains_only_valid_values? &&
    group_by_param_uniq? &&
    group_by_param_contain_maximum_one_time_related_value?
  end

  def group_by_param_exists?
    time_entry_params[:group_by].present?
  end

  def group_by_param_uniq?
    time_entry_params[:group_by].uniq.size == time_entry_params[:group_by].size
  end

  def group_by_param_contains_only_valid_values?
    (time_entry_params[:group_by] & VALID_GROUP_BY_PARAMS) == time_entry_params[:group_by]
  end

  def group_by_param_is_not_too_deep?
    time_entry_params[:group_by].size <= 2
  end

  def group_by_param_contain_maximum_one_time_related_value?
    (time_entry_params[:group_by] & VALID_GROUP_BY_TIME_PARAMS).size <= 1
  end
end
