class Coworker < ActiveRecord::Base
  has_many :time_entries, class_name: Work::TimeEntry
  has_many :days_off, class_name: Work::DaysOffPeriod
  has_many :daily_targets, class_name: Work::DailyCoworkerTarget
end