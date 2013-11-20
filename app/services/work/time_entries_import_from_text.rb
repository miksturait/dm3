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

class Work::TimeEntriesImportFromText

  def self.parse(text)
    text.strip.split("\n").collect do |text_line|
      SingleLine.new(text_line).attrs
    end
  end

  # To change this template use File | Settings | File Templates.

  class SingleLine < Struct.new(:text_line)
    def attrs
      {
          date: match[:date],
          start_at: match[:start_at],
          end_at: match[:end_at],
          work_unit: work_unit,
          comment: comment
      }
    end

    private

    def match
      @match ||= time_entry_line_regex.match(text_line)
    end

    def work_unit
      context.work_unit
    end

    def comment
      match[:comment].strip if match[:comment]
    end

    def context
      Work::TimeEntryContext.new(match[:context])
    end

    def time_entry_line_regex
      /^(?<date>[^\s]{10})\s+(?<start_at>[^\s]{5})\s+(?<end_at>[^\s]{5})\s+(?<context>[^\s]+)(?<comment>[^(\n)]+)?$/
    end
  end
end

