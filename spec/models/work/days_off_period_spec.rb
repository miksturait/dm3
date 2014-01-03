require 'spec_helper'

describe Work::DaysOffPeriod do
  let(:begin_of_week) { Date.today.beginning_of_week }
  let(:period) { begin_of_week..begin_of_week+13.days }

  let(:tom) { create(:coworker, name: 'Tom') }
  let!(:tom_day_off_before) {
    create(:days_off_period, coworker: tom, period: begin_of_week-5.days..begin_of_week-1.days) }
  let!(:tom_day_off_within_begin) {
    create(:days_off_period, coworker: tom, period: begin_of_week-1.days..begin_of_week+3.days) }

  let(:simon) { create(:coworker, name: 'Simon') }
  let!(:simon_day_off_within) {
    create(:days_off_period, coworker: simon, period: begin_of_week+5.days..begin_of_week+7.days) }
  let!(:simon_day_off_within_end) {
    create(:days_off_period, coworker: simon, period: begin_of_week+12.days..begin_of_week+13.days) }
  let!(:simon_day_off_after) {
    create(:days_off_period, coworker: simon, period: begin_of_week+16.days..begin_of_week+17.days) }

  let!(:official_day_off_within) { create(:days_off_period,
                                          period: begin_of_week+10.days..begin_of_week+10.days,
                                          comment: 'some day off') }

  let!(:official_day_off_out_off) { create(:days_off_period,
                                           period: begin_of_week+50.days..begin_of_week+50.days,
                                           comment: 'some day off') }

  context "only official day off's" do
    subject(:day_off_periods) { described_class.within_period(period).
        official_days_off.load }

    it { should match_array([official_day_off_within]) }
  end

  context "days off relevent for tom" do
    subject(:day_off_periods) { described_class.within_period(period).
        official_days_off_and_days_of_for_coworker(tom).load }

    it { should match_array([official_day_off_within, tom_day_off_within_begin]) }
  end

  context "days off relevent for simon" do
    subject(:day_off_periods) { described_class.within_period(period).
        official_days_off_and_days_of_for_coworker(simon).load }

    it { should match_array([official_day_off_within, simon_day_off_within, simon_day_off_within_end]) }
  end
end