require 'spec_helper'

describe Project do
  # has_many :invoices // TODO: this will not be part of that app
  pending 'V2 :: relation with other objects'

  pending 'active phase, require some further improvements'
  # first look if there is any active phase -
  #   * phase should have period (that should be exclusive within project)
  # next it find the latest phase that in addition should have empty period

  describe "#active_phase" do
    let(:project) { create(:project) }
    let(:phase) { project.active_phase }

    context "phases not defined" do
      it { expect { phase }.to change { project.phases.count }.from(0).to(1) }
      it { expect(phase.period).to be_nil }
    end

    let(:phase_in_past) { create(:phase, period: Date.today-3.days..Date.today-2.days,
                                 parent: project) }
    let(:phase_in_future) { create(:phase, period: Date.today+2.days..Date.today+2.days,
                                   parent: project) }
    let(:phase_in_present) { create(:phase, period: Date.today-1.days..Date.today+1.days,
                                    parent: project) }

    context "phases in past/future" do
      before do
        phase_in_past
        phase_in_future
      end

      it { expect { phase }.to change { project.phases.count }.from(2).to(3) }
      it { expect(phase.period).to be_nil }
    end

    context "phase in past/present/future" do
      before do
        phase_in_past
        phase_in_present
        phase_in_future
      end

      it { expect { phase }.to_not change { project.phases.count }.from(3) }
      it { expect(phase).to eq(phase_in_present) }
    end

    context "phase without period & past/future" do
      before do
        phase_in_past
        project.active_phase
        phase_in_future
      end

      it { expect { phase }.to_not change { project.phases.count }.from(3) }
      it { expect(phase.period).to be_nil }
    end
  end

  it { should validate_presence_of(:wuid) }
  it { should allow_value(*%w(hrm process_and_tools ccc metreno mikstura.it dm3)).for(:wuid) }
  it { should_not allow_value(*%w(hrm-manage a-a - -a a-)).for(:wuid) }
end