class Work::TimeEntryContext < Struct.new(:context_code)

  def work_unit
    begin
      detect_unit || phase
    rescue ActiveRecord::RecordNotFound => e
      @exception = {work_unit_id: [e]}
      return
    end
  end

  def exception
    @exception ? @exception : work_unit; @exception
  end

  private

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

  delegate :descendants, to: :phase

  def detect_unit
    if unit_uid
      try_to_recreate_work_unit_structure_based_on_youtrack
      descendants.where(wuid: unit_uid).first || phase.children.create(wuid: unit_uid)
    end
  end

  def try_to_recreate_work_unit_structure_based_on_youtrack
    begin
      rwusboy.process
    rescue => e
      Rails.logger.error("\n\n== YOUTRACK API FAILURE \n#{rwusboy}\n#{e}\n\n")
      # TODO we should notify erbit
    end if project.is_connected_with_youtrack?
  end

  def rwusboy
    @rwusboy ||=
        RecreateWorkUnitStructureBasedOnYoutrack.new(project, context_code)
  end

  delegate :project_wuid, :unit_uid, :nofollow, to: :context

  def context
    @context ||= Work::ContextFromTextCode.new(context_code)
  end

  class RecreateWorkUnitStructureBasedOnYoutrack < Struct.new(:project, :context_code)
    delegate :process, to: :rbowuc

    def rbowuc
      @rbowuc ||=
          Work::UnitStructureImport::RecreateBasedOnWorkUnitContext.new(active_phase, work_unit_contexts)
    end

    delegate :active_phase, to: :project
    delegate :work_unit_contexts, to: :issue

    def issue
      @issue ||=
          Work::UnitStructureImport::YouTrackIssue.new(youtrack, context_code)
    end

    def youtrack
      @youtrack ||=
          Work::UnitStructureImport::YouTrackConnection.new(youtrack_config.attrs)
    end

    def youtrack_config
      Work::UnitStructureImport::YouTrackConfig.new(youtrack_config_code)
    end

    def youtrack_config_code
      project.opts["youtrack"]
    end
  end
end
