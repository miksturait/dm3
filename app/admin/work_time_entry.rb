ActiveAdmin.register Work::TimeEntry do
  menu parent: "Work Unit's", priority: 6

  index do
    column 'work unit' do |time_entry|
      [time_entry.work_unit.ancestors[2..-1].map(&:name),
          time_entry.work_unit.name].flatten.compact.join(" > ")
    end
    column 'coworker' do |time_entry|
      time_entry.coworker.name
    end
    column :duration
    column :comment
    default_actions
  end

  def scoped_collection
    Work::TimeEntry.includes([:work_unit, :coworker])
  end
end
