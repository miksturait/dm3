require 'spec_helper'

describe Work::TimeEntryContext do
  context "can't find a project" do
    subject(:time_entry_context) { Work::TimeEntryContext.new('hrm') }

    its(:work_unit) { should be_nil }

    describe 'exception' do
      subject { time_entry_context.exception[:work_unit_id].first }

      it { should be_kind_of(ActiveRecord::RecordNotFound) }
      its(:message) { should eq('No Project defined with id: hrm') }
    end
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
    end
  end

  # reply from youtrack that is mock'ed is:
  # wuid's node: "2-8 Dec '13" / "1242" / "979" / "980"
  context "youtrack is configured for the project", :mock, :vcr do
    let!(:ccc) { create(:project, wuid: 'selleo', name: 'Selleo Web & Mobile', opts: {youtrack: 'ccc'}) }
    let(:phase) { ccc.active_phase }
    let(:time_entry_context) { Work::TimeEntryContext.new('selleo-980') }
    let(:work_unit) { time_entry_context.work_unit }

    context "work unit is already defined" do
      let!(:selleo_980) { phase.children.create(wuid: '980') }
      it { expect(work_unit).to eq(selleo_980) }
    end

    context "work unit is misssing, and ask YouTrackIssue" do
      before do
        ENV['YOUTRACK_CCC_URL'] = 'https://youtrack.mikstura.it'
        ENV['YOUTRACK_CCC_LOGIN'] = 'user'
        ENV['YOUTRACK_CCC_PASSWD'] = 'passwd'
      end

      context "something wen't wrong - e.g. youtrack is unavaible" do
        xit "create issue based on what is availble, and add notice"
      end

      context "response is returned" do
        let!(:sprint) { phase.children.create(wuid: "2-8 Dec '13") }

        it { expect { work_unit }.to change { phase.descendants.count }.from(1).to(4) }
      end
    end
  end
end