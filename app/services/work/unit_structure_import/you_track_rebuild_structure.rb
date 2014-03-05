class Work::UnitStructureImport::YouTrackRebuildStructure < Struct.new(:work_unit, :period)

  def work_units_map
    @work_units_map ||=
        prepare_work_units_map
  end

  private

  def prepare_work_units_map
    work_unit.time_entries.includes(:work_unit).within_period(period_as_time).
        select(:work_unit_id, :id).
        each_with_object(Hash.new { |h, k| h[k] = [] }) do |time_entry, cache|
      cache[time_entry.work_unit].push(time_entry.id)
    end
  end

  # TODO - this should be moved to within_period scope responsibility
  def period_as_time
    period.begin.in_time_zone..
        period.end.in_time_zone.end_of_day
  end
end