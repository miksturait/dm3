require 'spec_helper'

describe Work::TimeEntryContext do
  context "can't find a project - will raise an exception" do
    let(:time_entry_context) { Work::TimeEntryContext.new('hrm') }

    it { expect(time_entry_context.work_unit).to be_nil }

    subject(:exception) { time_entry_context.exception[:work_unit_id].first }
    it { should be_kind_of(ActiveRecord::RecordNotFound) }
    its(:message) { should eq('No Project defined with id: hrm') }
  end

  context "when project exists" do
    let!(:ccc) { create(:project, wuid: 'ccc', name: 'Credit Card Comparison') }
    let(:time_entry_context) { Work::TimeEntryContext.new('ccc') }
    let(:work_unit) { time_entry_context.work_unit }

    it { expect(work_unit.project).to eq(ccc) }

    context "can't find current phase - will create a new one" do
      it { expect { work_unit }.to change { Phase.count }.from(0).to(1) }
    end

    context "within existing phase" do
      let!(:current_phase) { ccc.active_phase }
      it { expect { work_unit }.to_not change { Phase.count } }

      context "no work unit defined - will use current phase as work unit" do
        it { expect(work_unit).to eq(current_phase) }
      end

      context "Time Entry Context have work unit defined" do
        let(:time_entry_context) { Work::TimeEntryContext.new('ccc-manage') }
        context "work of unit exists" do
          let!(:ccc_manage_unit) { current_phase.create_children(wuid: 'manage') }

          it { expect(work_unit).to eq(ccc_manage_unit) }
          it { expect { work_unit }.to_not change { Work::Unit.count } }
        end

        context "work of unit don't exist - will create a new work unit" do
          it { expect(work_unit.wuid).to eq('manage') }
          it { expect { work_unit }.to change { current_phase.children.count }.from(0).to(1) }
        end
      end

      pending "V0 :: fetching work unit structure from youtrack"
    end
  end
end