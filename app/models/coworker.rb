class Coworker < ActiveRecord::Base
  has_many :time_entries, class_name: Work::TimeEntry
end