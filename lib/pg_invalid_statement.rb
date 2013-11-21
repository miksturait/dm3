class PGInvalidStatement < Struct.new(:msg)

  def name
    match[:exception].sub(/:\s+\z/, '')
  end

  def error
    match[:error].sub(/\AERROR:\s+/,'')
  end

  def detail
    match[:detail].sub(/\ADETAIL:\s+/,'')
  end

  def statement
    match[:statement].strip
  end

  private

  def match
    @match ||= regex.match(msg)
  end

  def regex
    /(?<exception>.+:\s)(?<error>ERROR:.+)\n(?<detail>DETAIL:.*)\n:(?<statement>.*)/
  end
end