class Work::TimeEntriesImportFromText

  def self.parse(text)
    text.strip.split("\n").collect do |text_line|
      SingleLine.new(text_line).attrs
    end
  end

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

    def comment
      match[:comment].strip if match[:comment]
    end

    delegate :work_unit, to: :context

    def context
      Work::TimeEntryContext.new(match[:context])
    end

    def time_entry_line_regex
      /^(?<date>[^\s]{10})\s+(?<start_at>[^\s]{5})\s+(?<end_at>[^\s]{5})\s+(?<context>[^\s]+)(?<comment>[^(\n)]+)?$/
    end
  end
end

