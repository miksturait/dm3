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

  def phase
    @phase ||= project.active_phase
  end

  def project
    begin
      @project ||= Project.where(wuid: project_wuid).first!
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound, "No Project defined with id: #{project_wuid}"
    end
  end

  def detect_unit
    work_unit_recreator.recreate
    descendants.where(wuid: unit_uid).first || phase.children.create(wuid: unit_uid)
  end

  def work_unit_recreator
    project.work_unit_recreator_class.new(project, context_code)
  end

  def context
    @context ||= Work::ContextFromTextCode.new(context_code)
  end
end
