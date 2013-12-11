class Work::UnitStructureImport::YouTrackConfig < Struct.new(:youtrack_code)

  def attrs
    {
        url: get("URL"),
        login: get("LOGIN"),
        passwd: get("PASSWD")
    }
  end

  private

  def get(attr)
    ENV[env_key(attr)]
  end

  def env_key(attr)
    ["YOUTRACK", youtrack_code_upcase, attr].compact.join('_')
  end

  def youtrack_code_upcase
    youtrack_code.upcase if youtrack_code && !youtrack_code.empty?
  end
end