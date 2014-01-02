class Work::DaysOffPeriod < ActiveRecord::Base
  belongs_to :coworker

  scope :official_days_off_and_days_of_for_coworker, ->(coworker) { where(coworker_id: [coworker.id, nil]) }
  scope :official_days_off, -> { where(coworker_id: nil) }
  scope :within_period, ->(range) { where(["period && daterange(?,?, '[]')", range.begin.to_s, range.end.to_s]) }
end