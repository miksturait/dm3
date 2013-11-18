# It converts text lines in formats
#
#    2013-06-04	11:00	11:15	|	selleo-858
#    2013-06-04	12:15	13:30	|	metreno-853
#    2013-06-04	13:30	14:15	|	hrm - feedback for WR
#    2013-06-04	14:15	14:30	|	sourcyx-742
#    2013-06-04	14:30	14:45	|	selleo-760
#
# Into Array of Hashes, e.g:
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
#
# If any line is unprocessable the it raise exception with line number and content

class Workload::TabSeparatedSource
  # To change this template use File | Settings | File Templates.
end

