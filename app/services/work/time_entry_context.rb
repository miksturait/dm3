# based on the text description like:
# * hrm - feedback for WR
# * sourcyx-manage
# * sourcyx-jira::1235
# * ccc-132
# it returns hash, e.g.:
# {
#   workload_object: < Project / Milestone / Task >
#   comment: feedback for WR
# }
# if workload object is not find, then exception is raised

# if are not able to find and workload object
# and when node is redirecting to an external source e.g. youtrack, we are delegating
# context identification to specialize class

class Work::TimeEntryContext < Struct.new(:context_code)
  def work_unit
    detect_unit || phase
  end

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

  private

  def detect_unit
    phase.units.where(wuid: unit_uid).first_or_create if unit_uid
  end

  delegate :project_wuid, :unit_uid, :nofollow, to: :context

  def context
    @context ||= Context.new(context_code)
  end

  class Context < Struct.new(:context_code)

    def project_wuid
      match[:project]
    end

    def unit_uid
      match[:unit]
    end

    def nofollow
      match[:nofollow]
    end

    private

    def match
      context_regex.match(context_code)
    end

    def context_regex
      /^(?<project>[^\-]+)(\-(?<nofollow>(jira|nofollow|ext)::)?(?<unit>[^\n]+))?$/
    end
  end
end