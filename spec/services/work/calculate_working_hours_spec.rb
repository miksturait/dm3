require 'spec_helper'

describe Work::CalculateWorkingHours do
  let(:date) { Date.today.beginning_of_week }
  context "with custom working hours per day" do
    let(:period) { date..date+4 }
    subject { described_class.new(period, nil, 4) }

    it { should  have(5).working_days }
    its(:working_hours) { should eq(20) }
  end

  context "with default working hours per day" do
    let(:period) { date..date+6 }
    context "taking into account weekends" do
      subject { described_class.new(period) }

      it { should  have(5).working_days }
      its(:working_hours) { should eq(40) }
    end

    context "taking into account official days off" do
      let!(:day_off) { create(:days_off_period, period: date..date) }
      subject { described_class.new(period) }

      it { should  have(4).working_days }
    end

    context "coworker days off defined" do
      let(:tom) { create(:coworker, name: 'Tom') }
      let(:simon) { create(:coworker, name: 'Simon') }
      let!(:tom_day_off) { create(:days_off_period, period: date..date+1, coworker: tom) }
      let!(:simon_day_off) { create(:days_off_period, period: date+3..date+4, coworker: simon) }
      let!(:day_off) { create(:days_off_period, period: date..date) }

      context "coworker days off have no impact on general working days" do
        subject { described_class.new(period) }

        it { should  have(4).working_days }
      end
      context "only official and Tom days off taken for Tom" do
        subject { described_class.new(period, tom) }

        it { should  have(3).working_days }
      end

      context "only official and Simon days off taken for Simon" do
        subject { described_class.new(period, simon) }

        it { should  have(2).working_days }
      end
    end
  end
end