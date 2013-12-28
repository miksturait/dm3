require 'spec_helper'

describe Work::CalculateWorkingHours, :focus do
  let(:date) { Date.today.beginning_of_week }
  context "with custom working hours per day" do
    let(:period) { date..date+4 }
    subject { described_class.new(period, nil, 4) }

    its(:working_hours_for_business_day) { should eq(4) }
    its(:business_days) { should eq(5) }
    its(:hours) { should eq(20) }
  end

  context "with default working hours per day" do
    context "taking into account weekends" do
      let(:period) { date..date+6 }
      subject { described_class.new(period) }

      its(:working_hours_for_business_day) { should eq(8) }
      its(:business_days) { should eq(5) }
      its(:hours) { should eq(40) }
    end

    context "taking into account official days off" do

    end

    context "taking into account coworker days off" do

    end
  end
end