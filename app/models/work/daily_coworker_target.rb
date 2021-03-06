class Work::DailyCoworkerTarget < ActiveRecord::Base
  belongs_to :work_unit, class_name: Work::Unit
  belongs_to :coworker
  belongs_to :target, class_name: Work::Target

  validates :work_unit_id, presence: true
  validates :coworker_id, presence: true, if: -> (daily) { daily.target && !daily.target.coworker_id.blank? }

  scope :within_period, ->(period) { where(["day >= ? AND day <= ?", period.begin, period.end]) }
end