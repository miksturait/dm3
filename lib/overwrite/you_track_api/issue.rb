class YouTrackAPI::Issue
  def get
    body = REXML::Document.new(@conn.request(:get, path).body)
    REXML::XPath.each(body, "//issue/field") { |field|
      values = []
      case field.attributes["name"]
        when 'links'
          values = Hash.new { |hash, key| hash[key] = [] }
          REXML::XPath.each(body, field.xpath + "/value") { |value|
            values[value.attributes["role"].split.first] << value.text
          }
        else
          REXML::XPath.each(body, field.xpath + "/value") { |value|
            values << value.text
          }
      end
      create_getter_and_setter_and_set_value(field.attributes["name"], values)
    }
    self
  end
end
