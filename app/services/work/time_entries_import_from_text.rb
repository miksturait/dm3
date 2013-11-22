class Work::TimeEntriesImportFromText

  def self.parse(text)
    text.strip.split("\n").collect do |text_line|
      SingleLine.new(text_line).attrs
    end
  end

  class SingleLine < Struct.new(:text_line)
    def attrs
      {
          period: period,
          work_unit: work_unit,
          comment: comment,
          exception: exception
      }
    end

    private

    def match
      @match ||= time_entry_line_regex.match(text_line)
    end

    def period
      start_at..end_at
    end

    def start_at
      Time.parse(
          [match[:date], match[:start_at]].join(' '))
    end

    def end_at
      Time.parse(
          [match[:date], match[:end_at]].join(' '))
    end

    def comment
      match[:comment].strip if match[:comment]
    end

    delegate :work_unit, :exception, to: :context

    def context
      Work::TimeEntryContext.new(match[:context])
    end

    def time_entry_line_regex
      /^(?<date>[^\s]{10})\s+(?<start_at>[^\s]{5})\s+(?<end_at>[^\s]{5})\s+(?<context>[^\s]+)(?<comment>[^(\n)]+)?$/
    end
  end
end

