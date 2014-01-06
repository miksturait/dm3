class Work::TimeEntriesImportFromText < Struct.new(:raw_text)

  def attrs
    text.split("\n").collect do |text_line|
      SingleLine.new(text_line).attrs
    end
  end

  private

  def text
    raw_text.strip.gsub(/\n\s*\n/, "\n")
  end

  class SingleLine < Struct.new(:text_line)
    def attrs
      match ?
          fetch_attrs :
          unprocessable_line_attrs
    end

    private

    def fetch_attrs
      {
          period: period,
          work_unit: work_unit,
          comment: comment,
          exception: exception
      }
    end

    def unprocessable_line_attrs
      {
          exception: {
              base: [%Q{line: "#{text_line}" have wrong format}]
          }
      }
    end

    def match
      @match ||= time_entry_line_regex.match(text_line)
    end

    def period
      start_at..end_at
    end

    def start_at
      get_date_of(:start_at)
    end

    def end_at
      get_date_of(:end_at)
    end

    def get_date_of(limit)
      Time.parse(
          [match[:date], match[limit]].join(' '))
    end

    def comment
      match[:comment].strip if match[:comment]
    end

    delegate :work_unit, :exception, to: :context

    def context
      Work::TimeEntryContext.new(match[:context])
    end

    def time_entry_line_regex
      /^(?<date>[^\s]{10})\s+(?<start_at>[^\s]{5})\s+(?<end_at>[^\s]{5})\s+(?<context>[^\s]+)(?<comment>[^\n]+)?$/
    end
  end
end

