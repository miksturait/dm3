FactoryGirl.define do
  factory :time_entry, class: Work::TimeEntry do
    period { Time.now-2.hours..Time.now }
    user
  end
end