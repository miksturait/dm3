# * should have uid and aliases
class Work::Unit
  has_many :time_entries, class_name: 'Work::TimeEntry'
end