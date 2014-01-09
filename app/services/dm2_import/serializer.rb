class DM2Import::Serializer < ActiveModel::Serializer
  self.root = false
  attributes :errors, :time_entries, :time_entries_data

  def time_entries
    time_entries_persisted_collection.collect do |time_entry|
      work_unit = time_entry.work_unit
      "#{time_entry.duration} minutes on".rjust(15).ljust(20) << " : " <<
          work_unit_ancestors_names(work_unit).reverse.join(' < ') <<
          " [#{time_entry.comment}]"
    end
  end

  def errors
    object.errors.collect do |error|
      if error.kind_of?(ActiveRecord::Base)
        "#{error.class.name} :: #{error.errors.messages} \n (#{error.attributes})"
      else
        error
      end
    end
  end

  private

  def work_unit_ancestors_names(work_unit)
    (work_unit.ancestors.select(:name, :wuid)[1..-1] << work_unit).collect { |wu| wu.name || wu.wuid }
  end

  def time_entries_persisted_collection
    (object.time_entries || []).select do |time_entry|
      time_entry.persisted?
    end.sort_by(&:work_unit_id)
  end
end