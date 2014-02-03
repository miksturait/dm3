FactoryGirl.define do
  sequence :wuid do |n|
    "project_#{n}"
  end

  factory :project do
    wuid { generate(:wuid) }
  end

  factory :work_unit, class: Work::Unit do
    wuid { generate(:wuid) }
  end
end