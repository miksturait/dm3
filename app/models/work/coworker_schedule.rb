class Work::CoworkerSchedule < ActiveRecord::Base
  belongs_to :work_unit
  belongs_to :coworker, class_name: Coworker
end