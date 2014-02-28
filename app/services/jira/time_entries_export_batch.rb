# https://docs.atlassian.com/jira/REST/ondemand/#d2e4795
module Jira
  class TimeEntriesExportBatch
    USERS_MAP = {
        'boro.selleo@gmail.com' => 't.borowski@selleo.com',
        'wojtek.ryrych@gmail.com' => 'wojtek.ryrych@gmail.com',
        'arek.mp@gmail.com' => 'arek.mp@gmail.com',
    }
    FALLBACK_USERNAME = 't.borowski@selleo.com'

    attr_reader :jira_export_objects, :coworker

    def initialize(coworker, jira_export_objects)
      @coworker = coworker
      @jira_export_objects = jira_export_objects
    end

    def perform
      jira_export_objects.each do |jira_export_object|
        Jira::TimeEntryExport.new(jira_client, jira_export_object).perform
      end
    end

    private

    def jira_client
      @jira_client ||= JIRA::Client.new(jira_client_options)
    end

    def jira_client_options
        {
            username: username,
            password: password,
            site: site,
            context_path: '',
            auth_type: :basic
        }
    end

    def username
      USERS_MAP[coworker.email] || FALLBACK_USERNAME
    end

    def password
      auth_data[username]
    end

    def auth_data
      ENV['JIRA_AUTH'].split(',').each_with_object({}) do |auth_string, hsh|
        username, password = auth_string.split(':')
        hsh[username] = password
      end
    end

    def site
      ENV['JIRA_URL']
    end
  end
end
