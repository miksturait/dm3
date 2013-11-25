require 'spec_helper'

describe Work::Unit do

  describe "set type" do
    let(:project) { create(:project, wuid: 'metreno') }

    let(:phase) { project.create_children(name: 'Phase One') }
    it { expect(phase).to be_a(Phase) }

    let(:work_unit) { phase.create_children(wuid: 'some_work-1243') }
    it { expect(work_unit).to be_a(Work::Unit) }
  end

  describe "validation" do
    it { should validate_presence_of(:wuid) }
  
    describe "uniqueness of wuid" do
      let(:metreno) { create(:project, wuid: 'metreno') }
      let(:metreno_phase_one) { metreno.create_children(name: 'Phase One') }
      let(:metreno_phase_two) { metreno.create_children(name: 'Phase Two') }
  
      let(:ccc) { create(:project, wuid: 'ccc') }
      let(:ccc_phase_one) { ccc.create_children(name: 'Phase One') }
  
  
      before do
        metreno_phase_one.create_children!(wuid: 'wk-1')
        metreno_phase_two.create_children!(wuid: 'wk-2')
        ccc_phase_one.create_children!(wuid: 'wki')
      end
  
      context "will prevent creating another node on the same level" do
        it { expect { create(:project, wuid: 'metreno') }.
            to raise_error(ActiveRecord::RecordInvalid) }
        it { expect { metreno_phase_one.create_children!(wuid: 'wk-1') }.
            to raise_error(ActiveRecord::RecordInvalid) }
      end
  
      context "will allow for the same wuid on different tree level" do
        it { expect { metreno_phase_one.create_children!(wuid: 'wk-2') }.
            to change { metreno_phase_one.children.count }.by(1) }
        it { expect { create(:project, wuid: 'wki') }.
            to change { Project.count }.by(1) }
      end
    end
  end
end