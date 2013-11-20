class Work::TimeImport < Struct.new(:user, :time_entries_data)

  def import!
    ActiveRecord::Base.transaction do
      time_entries_attrs.each do |time_entry_attrs|
        create_time_entry(time_entry_attrs)
      end
    end
  end

  private

  def time_entries_attrs
    Work::TimeEntriesImportFromText.parse(time_entries_data)
  end

  delegate :time_entries, to: :user

  def create_time_entry(attrs)
    time_entries.create!(attrs)
  end
end