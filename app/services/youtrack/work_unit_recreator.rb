module Youtrack
  class WorkUnitRecreator < Struct.new(:project, :context_code)
    delegate :active_phase, to: :project
    delegate :work_unit_contexts, to: :issue
    delegate :leaf, to: :creator, allow_nil: true

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
