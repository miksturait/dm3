class Work::TimeImport < Struct.new(:coworker, :time_entries_data)
  attr_accessor :errors
  attr_reader :time_entries

  def import!
    ActiveRecord::Base.transaction do
      clear_errors
      import_time_entries
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def read_attribute_for_serialization(attr)
    public_send(attr)
  end

  private

  def valid?
    validate.empty?
  end

  def validate
    @validate ||= collect_time_entries_errors
  end

  def collect_time_entries_errors
    errors.push(*invalid_time_entries)
  end

  def invalid_time_entries
    time_entries.select { |time_entry| time_entry.errors.present? }
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
    coworker.time_entries.create(attrs)
  end

  def time_entries_attrs
    Work::TimeEntriesImportFromText.new(time_entries_data).attrs
  end
end