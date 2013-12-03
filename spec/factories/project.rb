FactoryGirl.define do
  sequence :wuid do |n|
    "project_#{n}"
  end

  factory :project do
    wuid { generate(:wuid) }
  end
end