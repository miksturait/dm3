require 'spec_helper'

describe Phase do
  # has_many :invoices // TODO: this will not be part of that app
  pending 'V2 :: relation with other objects'

  it { should_not allow_value(*%w(hrm process_and_tools ccc metreno)).for(:wuid) }
  it { should allow_value(nil).for(:wuid) }

  describe "period range exclusion" do
    let(:project) { create(:project) }
    let!(:some_phase) { create(:phase, period: Date.today-2.days..Date.today+2.days,
                               parent: project) }
    let(:bad_phase) { build(:phase, period: Date.today+1.days..Date.today+3.days,
                            parent: project) }
    let(:good_phase) { build(:phase, period: Date.today-5.days..Date.today-3.days,
                             parent: project) }

    describe "finding exclusion" do
      it { expect(bad_phase).to be_inclusive }
      it { expect(good_phase).to_not be_inclusive }
    end

    context "trying to save bad record" do
      before { bad_phase.save }

      it { expect(bad_phase).to be_new_record }
      it { expect(bad_phase).to_not be_valid }
    end
  end
end