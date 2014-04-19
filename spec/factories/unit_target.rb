FactoryGirl.define do
  factory :unit_target, class: Work::UnitTarget do
    work_unit { create(:phase) }
  end
end
