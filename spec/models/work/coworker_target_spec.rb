require 'spec_helper'

describe Work::CoworkerTarget do
  let(:begin_of_phase) { Date.today.beginning_of_week }
  let(:end_of_phase) { begin_of_phase+13.days }
  let(:range_of_phase) { begin_of_phase..end_of_phase }
  let(:work_unit) { create(:phase, period: range_of_phase) }
  let(:coworker) { create(:coworker) }

  context "default values" do
    subject(:coworker_target) { create(:coworker_target, work_unit: work_unit, coworker: coworker) }

    its(:period) { should eq work_unit.period }
    its(:hours_per_day) { should eq(8)}
    its(:cache_of_total_hours) { should eq(80) }
  end

  context "custom period & number of hours per days" do
    let(:working_period) { begin_of_phase+2..begin_of_phase+5 }
    subject(:coworker_target) { create(:coworker_target,
                                       work_unit: work_unit, coworker: coworker,
                                       hours_per_day: 5, period: working_period) }

    its(:cache_of_total_hours) { should eq(15) }
  end

  pending 'V0 :: user schedule (split targets into days)'
  # def cache_coworker_target
  #   Work::CoworkerTargetCache.cache(self)
  # end
end