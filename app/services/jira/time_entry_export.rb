module Jira
  class TimeEntryExport
    VALID_WUID_REGEX = /\Ajira::spd-\d+\z/
    ISSUE_MAP = {
        'manage' => 'SPD-565',
        'communication' => 'SPD-566',
        'qa' => 'SPD-567',
    }

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
      if Rails.env.production?
        on_opened_issue do
          worklog_object.save({'timeSpentSeconds' => seconds_spent.to_s,
                               'started' => "#{date_as_text}T#{time_as_text}.000+0000"})
        end
      else
        true
      end
    end

    def on_opened_issue
      if issue_closed?
        open_issue!
        yield
        close_issue!
      else
        yield
      end
    end

    def open_issue!
      apply_transition(3)
    end

    def close_issue!
      apply_transition(2)
    end

    def apply_transition(transition_id)
      jira_issue.transitions.build.save({'transition' => {'id' => transition_id.to_s}})
    end

    def issue_closed?
      jira_issue.status.name == 'Closed'
    end

    def date_as_text
      time.strftime('%Y-%m-%d')
    end

    def time_as_text
      time.strftime('%H:%M:%S')
    end

    def time
      jira_export_object.time_entry.period.begin
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
     @jira_issue ||= begin
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
        ISSUE_MAP[work_unit_id]
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
