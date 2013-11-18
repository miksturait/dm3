# it takes array of hashes and convert it into time entries for a particular user e.g:
# [
#   {
#     data:             '2013-06-04',
#     start_at:         '13:30,'
#     end_at:           '14:15',
#     workload_object:  <project::hrm>
#     comment:          'feedback for WR'
#   },
#   ...
# ]

class Work::TimeImport < Struct.new(:user, :time_entries_attributes)
end