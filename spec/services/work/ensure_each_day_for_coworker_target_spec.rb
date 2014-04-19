require 'spec_helper'

describe Work::EnsureEachDayForCoworkerTarget do
  let(:monday) { Date.today.beginning_of_week }
  let(:five_working_days) { (monday..monday+4.days) }
  let(:coworker_target) { build(:coworker_target, id: 1,
                                work_unit_id: 2, coworker_id: 3, hours_per_day: 8) }

  before do
    coworker_target.stub(:working_days).and_return(five_working_days.to_a)
    coworker_target.stub(:new_record?).and_return(false)
  end

  let(:create_service_object) { described_class.new(coworker_target) }
  let(:create_daily_coworker_targets) { create_service_object.process }

  describe "creating" do
    it { expect { create_daily_coworker_targets }.to change { coworker_target.daily_targets.count }.from(0).to(5) }

    context "last daily coworker target" do
      before { create_daily_coworker_targets }
      subject { Work::DailyCoworkerTarget.last }

      its(:day) { should eq(five_working_days.last) }
      its(:target_id) { should eq(1) }
      its(:work_unit_id) { should eq(2) }
      its(:coworker_id) { should eq(3) }
      its(:hours) { should eq(8) }
    end
  end

  describe "upgrading" do
    let(:three_working_days) { five_working_days.to_a[1..-2] }
    before do
      create_daily_coworker_targets
      coworker_target.stub(:working_days).and_return(three_working_days)
      coworker_target.hours_per_day = 4
      coworker_target.work_unit_id = 5
    end
    let(:update_service_object) { described_class.new(coworker_target) }
    let(:update_daily_coworker_targets) { update_service_object.process }

    it { expect { update_daily_coworker_targets }.to change { coworker_target.daily_targets.count }.from(5).to(3) }

    context "last daily coworker target" do
      before { update_daily_coworker_targets }
      subject { coworker_target.daily_targets.last }

      its(:day) { should eq(three_working_days.last) }
      its(:target_id) { should eq(1) }
      its(:work_unit_id) { should eq(5) }
      its(:coworker_id) { should eq(3) }
      its(:hours) { should eq(4) }
    end
  end
end

