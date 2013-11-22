class Work::TimeImport < Struct.new(:user, :time_entries_data)
  attr_accessor :errors
  attr_reader :time_entries

  def import!
    ActiveRecord::Base.transaction do
      clear_errors
      import_time_entries
      raise ActiveRecord::Rollback unless valid?
    end
  end

  private

  def valid?
    validate.empty?
  end

  def validate
    @validate ||= collect_errors_from_time_entries
  end

  def collect_errors_from_time_entries
    time_entries.each do |te|
      unless te.errors.empty?
        errors << te
      end
    end
    errors
  end

  def clear_errors
    self.errors = []
  end

  def import_time_entries
    @time_entries = time_entries_attrs.collect do |time_entry_attrs|
      create_time_entry(time_entry_attrs)
    end
  end

  def create_time_entry(attrs)
    user.time_entries.create(attrs)
  end

  def time_entries_attrs
    Work::TimeEntriesImportFromText.parse(time_entries_data)
  end
end