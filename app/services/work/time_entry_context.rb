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

  delegate :units, to: :phase

  def detect_unit
    units.where(wuid: unit_uid).first_or_create if unit_uid
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
      /^(?<project>[^\-]+)(\-(?<unit>[^\n]+))?$/
    end
  end
end