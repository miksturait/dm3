class Jira::Export < ActiveRecord::Base
  self.table_name = 'jira_exports'

  belongs_to :time_entry, class_name: Work::TimeEntry

  delegate :coworker, :duration, :work_unit, to: :time_entry
end
