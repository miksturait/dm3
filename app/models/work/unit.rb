class Work::Unit < ActiveRecord::Base
  self.table_name = 'work_units'
  has_ancestry
  has_many :time_entries, class_name: 'Work::TimeEntry'

  def time_entries
    Work::TimeEntry.where(work_unit_id: subtree_ids)
  end
end