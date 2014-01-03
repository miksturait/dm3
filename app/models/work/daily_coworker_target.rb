class Work::DailyCoworkerTarget < ActiveRecord::Base
  belongs_to :work_unit, class_name: Work::Unit
  belongs_to :coworker
  belongs_to :coworker_target, class_name: Work::CoworkerTarget

  validates :work_unit_id, presence: true
  validates :coworker_id, presence: true
end