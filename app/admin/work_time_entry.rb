ActiveAdmin.register Work::TimeEntry do
  menu parent: "Work Unit's", priority: 6

  index do
    column 'work unit' do |time_entry|
      [time_entry.work_unit.ancestors[2..-1].collect {|wu| [wu.wuid, wu.name].compact.first },
       time_entry.work_unit.wuid,
       time_entry.work_unit.name].flatten.compact.join(" > ")
    end
    column :comment
    column 'coworker' do |time_entry|
      time_entry.coworker.name
    end
    column 'start at' do |time_entry|
      time_entry.period.begin.to_s(:short)
    end
    column :duration
    default_actions
  end

  controller do
    def scoped_collection
      Work::TimeEntry.includes([:work_unit, :coworker])
    end
  end

end
