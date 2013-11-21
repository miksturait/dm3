FactoryGirl.define do
  factory :time_entry, class: Work::TimeEntry do
    start_at Time.now-2.hours
    end_at Time.now
    period { Time.now-2.hours..Time.now }
    user
  end
end