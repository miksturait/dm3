# It require url, login, passwd as attributes
class Work::UnitStructureImport::YouTrackConnection < OpenStruct

  def connection
    ensure_connection
  end

  private

  def ensure_connection
    # don't why, but I've authorize on every request
    youtrack_connection.tap { |_| auth }
  end

  def youtrack_connection
    @youtrack_connection ||= YouTrackAPI::Connection.new(url).tap do |youtrack_connection|
      youtrack_connection.set_logger(logger)
    end
  end

  def auth
    youtrack_connection.login(login, passwd)
  end

  def logger
    lambda { |method, path, headers|
      Rails.logger.info "YOUTRACK :: #{method.to_s.upcase} #{path}"
    }
  end
end