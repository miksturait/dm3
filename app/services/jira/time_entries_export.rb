# Custom code

module Jira
  PROJECT_WUID = 'sourcyx'.freeze

  class TimeEntriesExport
    def perform
      create_missing_jira_export_objects
      process_pending_jira_export_object
    end

    private

    def create_missing_jira_export_objects
      project_time_entries_without_jira_export_objects.each do |time_entry|
        Jira::Export.create(time_entry_id: time_entry.id)
      end
    end

    def work_unit
      Work::Unit.find_by(wuid: PROJECT_WUID)
    end

    def project_time_entries_without_jira_export_objects
      work_unit.time_entries.
          joins('LEFT OUTER JOIN jira_exports ON jira_exports.time_entry_id = time_entries.id').
          where('jira_exports.id' => nil)
    end

    def pending_jira_export_objects
      Jira::Export.where(processed_at: nil)
    end

    def process_pending_jira_export_object
      pending_jira_export_objects.group_by(&:coworker).each do |coworker, jira_export_objects|
        TimeEntriesExportBatch.new(coworker, jira_export_objects).perform
      end
    end
  end
end
