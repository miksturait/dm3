class Work::UnitStructureImport::YouTrackIssue < Struct.new(:youtrack, :master_issue_id)

  def work_unit_contexts
    [
        sprint,
        ancestors,
        master
    ].compact.flatten
  end

  private

  def sprint
    Info::WorkUnitContext.new master_issue.sprint, nil
  end

  def ancestors
    detect_ancestors(master_issue).map(&:work_unit_context)
  end

  def detect_ancestors(issue)
    [detect_ancestors(issue.parent), issue.parent].compact.flatten if issue.parent
  end

  def master
    master_issue.work_unit_context
  end


  def master_issue
    @master_issue = Info.new(connection, master_issue_id)
  end

  delegate :connection, to: :youtrack

  class Info < Struct.new(:connection, :id)

    def work_unit_context
      WorkUnitContext.new(id, summary)
    end

    class WorkUnitContext < Struct.new(:wuid, :name)
    end

    def sprint
      extract :sprint
      issue.sprint.first if issue.sprint && issue.sprint.any?
    end

    def summary
      extract :summary
    end

    def parent
      @parent ||=
          self.class.new(connection, parent_id) if parent_id
    end

    private

    def parent_id
      detect_parent_id
    end

    def detect_parent_id
      links["subtask"].first if any_subtask?
    end

    def any_subtask?
      links && links.has_key?("subtask")
    end

    def links
      issue.links
    end

    def extract(attr)
      if issue.respond_to?(attr) && issue.send(attr).any?
        issue.send(attr).first
      end
    end

    def issue
      @issue ||= YouTrackAPI::Issue.new(connection, id).get
    end
  end
end