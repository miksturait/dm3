module Jira
  class TimeEntryExport
    VALID_WUID_REGEX = /\Ajira::spd-\d+\z/

    attr_reader :jira_client, :jira_export_object

    def initialize(jira_client, jira_export_object)
      @jira_client = jira_client
      @jira_export_object = jira_export_object
    end

    def perform
      if issue_identifier
        if worklog_object
          if save_worklog!
            save_message("Saved #{seconds_spent.to_s} for #{issue_identifier} ")
            success!
          else
            save_error("Cannot save worklog for #{seconds_spent} seconds")
          end
        else
          save_error("Cannot prepare worklog object for #{issue_identifier} and #{seconds_spent} seconds")
        end
      else
        save_error("Cannot retrieve issue identifier out of \"#{work_unit_id}\"")
      end
    end

    private

    def save_worklog!
      worklog_object.save({'timeSpentSeconds' => seconds_spent.to_s})
    end

    def jira_client_username
      jira_client.options[:username]
    end

    def worklog_object
      return nil unless jira_issue
      jira_issue.worklogs.build
    end

    def coworker_email
      jira_export_object.coworker.try(:email)
    end

    def jira_issue
      begin
        jira_client.Issue.find(issue_identifier)
      rescue JIRA::HTTPError
        save_error("Cannot find issue #{issue_identifier}")
        nil
      end
    end

    def seconds_spent
      jira_export_object.duration * 60
    end

    def issue_identifier
      if work_unit_id =~ VALID_WUID_REGEX
        work_unit_id.split('::').last.upcase
      else
        nil
      end
    end

    def work_unit_id
      jira_export_object.work_unit.wuid
    end

    def success!
      jira_export_object.touch(:processed_at)
    end

    def save_message(message)
      jira_export_object.update_column(:last_error, "#{message} as #{jira_client_username} (#{coworker_email})")
    end

    alias_method :save_error, :save_message
  end
end