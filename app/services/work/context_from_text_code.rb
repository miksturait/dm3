class Work::ContextFromTextCode < Struct.new(:context_code)
  def project_wuid
    match[:project].try(:downcase)
  end

  def unit_uid
    match[:unit]
  end

  private

  def match
    context_regex.match(context_code)
  end

  def context_regex
    /^(?<project>[^\-]+)(\-(?<unit>[^\n]+))?$/
  end
end
