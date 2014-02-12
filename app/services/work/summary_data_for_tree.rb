class Work::SummaryDataForTree < Struct.new(:params)
  def data
    root_data + descendants_data
  end

  private

  def root_data
    [
        decorate_work_unit(work_unit, true).tap { |work_unit_info| work_unit_info.delete(:parent_id) }
    ]
  end

  def descendants_data
    descendants_sorted.collect { |work_unit| decorate_work_unit(work_unit) }.compact
  end

  def decorate_work_unit(work_unit, include_empty=false)
    if (workload = work_unit.time_entries.within_period(period).sum(:duration)) > 0 or include_empty
      {id: work_unit.id, parent_id: work_unit.parent_id, label: work_unit.label, workload: workload}
    end
  end

  def descendants_sorted
    descendants.sort_by { |work_unit| [work_unit.ancestry, work_unit.id].join("/") }
  end

  delegate :descendants, to: :work_unit

  def work_unit
    @work_unit ||=
        Work::Unit.find(opts.work_unit_id)
  end

  def period
    start_at..end_at
  end

  def start_at
    Date.parse(opts.start_at).beginning_of_day
  end

  def end_at
    Date.parse(opts.end_at).end_of_day
  end

  def opts
    OpenStruct.new(params)
  end
end