class Work::ContextFromTextCode < Struct.new(:context_code)
  def project_wuid
    match_project_wuid
  end

  def unit_uid
    match[:unit]
  end

  def nofollow
    match[:nofollow]
  end

  private

  def match_project_wuid
    if match[:project]
      match[:project].downcase
    end
  end

  def match
    context_regex.match(context_code)
  end

  def context_regex
    /^(?<project>[^\-]+)(\-(?<unit>[^\n]+))?$/
  end
end