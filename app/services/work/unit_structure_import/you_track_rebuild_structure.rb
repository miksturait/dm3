class Work::UnitStructureImport::YouTrackRebuildStructure < Struct.new(:phase, :period)

  def process
    ActiveRecord::Base.transaction do
      work_units_map.each do |work_unit, time_entry_ids|
        if /^\d+$/.match(work_unit.wuid)
          RebuildTreeForWorkUnit.new(phase, work_unit, time_entry_ids).process
        end
      end
    end
  end

  private

  class RebuildTreeForWorkUnit < Struct.new(:phase, :work_unit, :time_entry_ids)
    delegate :wuid, to: :work_unit
    delegate :descendants, to: :phase
    delegate :work_unit_recreator_class, to: :project

    def process
      move_time_entries_to_new_work_unit if new_work_unit != work_unit
    end

    def new_work_unit
      @new_work_unit ||
          detect_unit
    end

    private

    def move_time_entries_to_new_work_unit
      Work::TimeEntry.where(id: time_entry_ids).update_all(work_unit_id: new_work_unit.id)
    end

    def detect_unit
      work_unit_recreator.recreate
      work_unit_recreator.leaf || work_unit
    end

    def work_unit_recreator
      @work_unit_recreator ||=
          work_unit_recreator_class.new(phase, youtrack_issue_id)
    end

    def youtrack_issue_id
      [project.wuid, wuid].join('-')
    end

    def project
      work_unit.is_a?(Project) ?
          work_unit :
          work_unit.ancestors.where(type: 'Project').first!
    end
  end

  def work_units_map
    @work_units_map ||=
        prepare_work_units_map
  end


  def prepare_work_units_map
    phase.time_entries.includes(:work_unit).within_period(period_as_time).
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