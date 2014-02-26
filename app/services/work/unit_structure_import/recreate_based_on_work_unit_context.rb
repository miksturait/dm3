class Work::UnitStructureImport::RecreateBasedOnWorkUnitContext < Struct.new(:phase, :work_units_context)
  def process
    find_or_create_child(phase, next_child_work_unit_context)
  end

  def find_or_create_child(parent, work_unit_context)
    return if work_unit_context.nil?
    parent.children.where(
        wuid: work_unit_context.wuid,
        name: work_unit_context.name
    ).first_or_create.
        tap { |potential_parent| find_or_create_child(potential_parent, next_child_work_unit_context) }
  end

  private

  def next_child_work_unit_context
    work_units_context_reversed.pop
  end

  def work_units_context_reversed
    @work_units_context_reversed ||= work_units_context.reverse
  end
end
