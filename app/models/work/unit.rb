# * should have uid and aliases
# * uniqueness of wuid
#   => customer within company
#   => project within customer
#   => phase have no wuid
#   => all children within phase
class Work::Unit < ActiveRecord::Base
  self.table_name = 'work_units'
  has_ancestry
  has_many :time_entries, class_name: 'Work::TimeEntry'
end