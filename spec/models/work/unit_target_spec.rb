require 'spec_helper'

describe Work::UnitTarget do
  let(:begin_of_phase) { Date.today.beginning_of_week }
  let(:end_of_phase) { begin_of_phase+13.days }
  let(:range_of_phase) { begin_of_phase..end_of_phase }
  let(:work_unit) { create(:phase, period: range_of_phase) }

  context "creating target for work unit - tracking paid hours" do
    subject(:unit_target) { create(:unit_target, work_unit: work_unit) }

    its(:period) { should eq work_unit.period }
    its(:hours_per_day) { should eq(8)}
    its(:cache_of_total_hours) { should eq(80) }

    it { should have(10).daily_targets }
  end
end