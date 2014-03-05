class Work::TimeEntryContext < Struct.new(:context_code)
  def work_unit
    begin
      (detect_unit if unit_uid) || phase
    rescue ActiveRecord::RecordNotFound => e
      @exception = {work_unit_id: [e]}
      return
    end
  end

  def exception
    @exception ? @exception : work_unit
    @exception
  end

  private

  delegate :descendants, to: :phase
  delegate :project_wuid, :unit_uid, to: :context
  delegate :work_unit_recreator_class, to: :project

  def phase
    @phase ||= project.active_phase
  end

  def project
    @project ||= Project.where(wuid: project_wuid).first!
  rescue ActiveRecord::RecordNotFound
    raise ActiveRecord::RecordNotFound, "No Project defined with id: #{project_wuid}"
  end

  def detect_unit
    work_unit_recreator.recreate
    descendants.where(wuid: unit_uid).first ||
        phase.children.create(wuid: unit_uid)
  end

  def work_unit_recreator
    @work_unit_recreator_class ||=
        work_unit_recreator_class.new(project, context_code)
  end

  def context
    @context ||= Work::ContextFromTextCode.new(context_code)
  end
end
