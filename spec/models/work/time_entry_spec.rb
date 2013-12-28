require 'spec_helper'

describe Work::TimeEntry do

  describe "period range exclusion" do
    let!(:first_time_entry) { create(:time_entry, coworker_id: 2, period: Time.now-2.hours..Time.now) }
    let(:bad_time_entry) { build(:time_entry, coworker_id: 2, period: Time.now-1.hours..Time.now+1.hours) }
    let(:good_time_entry) { build(:time_entry, coworker_id: 2, period: Time.now+1.hours..Time.now+3.hours) }

    describe "finding exclusion" do
      it { expect(bad_time_entry).to be_inclusive }
      it { expect(good_time_entry).to_not be_inclusive }
    end

    context "trying to save bad record" do
      before { bad_time_entry.save }

      it { expect(bad_time_entry).to be_new_record }
      it { expect(bad_time_entry).to_not be_valid }
    end
  end

  #   EFFORT_TYPE_REGEX =  /(regular|overtime|weekend|on-site)/i
  pending "V3 :: time entry types"
end