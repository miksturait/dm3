FactoryGirl.define do
  factory :coworker_target, class: Work::CoworkerTarget do
    work_unit { create(:phase) }
    coworker
  end
end
