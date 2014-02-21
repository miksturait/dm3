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
    if project.is_connected_with_youtrack?
      youtrack_recreator.recreate
    end
    descendants.where(wuid: unit_uid).first || phase.children.create(wuid: unit_uid)
  end

  def youtrack_recreator
    @youtrack_recreator ||=
        Youtrack::RecreateWorkUnitStructure.new(project, context_code)
  end

  def context
    @context ||= Work::ContextFromTextCode.new(context_code)
  end

  module Youtrack
    class RecreateWorkUnitStructure < Struct.new(:project, :context_code)
      delegate :active_phase, to: :project
      delegate :work_unit_contexts, to: :issue

      def recreate
        creator.process
      rescue => e
        Rails.logger.error("\n\n== YOUTRACK API FAILURE \n#{self}\n#{e}\n\n")
        # TODO we should notify erbit
      end

      def creator
        @creator ||=
            Work::UnitStructureImport::RecreateBasedOnWorkUnitContext.new(active_phase, work_unit_contexts)
      end

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
        project.opts['youtrack']
      end
    end
  end
end
