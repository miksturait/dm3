require 'spec_helper'

describe Work::UnitStructureImport::YouTrackRebuildStructure do

  let(:project) { create(:project, opts: {youtrack: 'ccc'}, wuid: 'ccc') }
  let(:phase) { create(:phase, parent: project) }
  let(:other_phase) { create(:phase, parent: project) }
  let(:some_work_unit) { other_phase.create_children(wuid: '4533') }
  let(:sprint) { build_context("2-8 Dec '13", nil) }
  let(:child) { build_context("979", "knowledge pack I") }
  let(:a_good_child) { build_context("1040", "good piece of work") }
  let!(:import) do
    create_context_class.new(phase, [sprint, child]).process
    create_context_class.new(phase, [sprint, a_good_child]).process
  end
  let(:simon) { create(:coworker, email: 'simon@m.it') }

  let(:period) { Date.new(2014, 1, 1)..Date.new(2014, 1, 31) }

  let(:child_work_unit) { phase.descendants.where(wuid: '979').first }
  let(:a_good_child_work_unit) { phase.descendants.where(wuid: '1040').first }

  before do
    [[1.day, 60.minutes, some_work_unit],
     [2.days, 90.minutes, child_work_unit],
     [3.days, 50.minutes, child_work_unit],
     [5.days, 12.minutes, a_good_child_work_unit],
     [-4.days, 15.minutes, child_work_unit]].each do |(offset, duration, work_unit)|
      period_offset = (period.begin + offset).in_time_zone
      simon.time_entries.create(work_unit: work_unit,
                                period: period_offset..period_offset+duration)
    end
  end

  let(:youtrack_rebuild_structure) { described_class.new(phase, period) }

  let(:root) { build_context("1242", "HRM ( recruitment / skills development & dessimination )") }
  let(:group) { build_context("980", "Troubleshooting, The Developer's #1 Skill") }
  let(:updated_child) { sprint.children.create("979", "some new name") }

  context "different ancestors structure and different name of ticket" do
    before do
      double_work_unit_context = double('Work::UnitContext')
      double_work_unit_context.stub(:work_unit_contexts).and_return([sprint, root, group, child])
      double_a_good_work_unit_context = double('Work::UnitContext')
      double_a_good_work_unit_context.stub(:work_unit_contexts).and_return([sprint, a_good_child])

      @@youtrack_work_unit_recreator_issue = [double_a_good_work_unit_context,
                                              double_work_unit_context]

      Youtrack::WorkUnitRecreator.any_instance.stub(:issue) do
        @@youtrack_work_unit_recreator_issue.pop
      end
    end

    let(:process) { youtrack_rebuild_structure.process }

    it { expect { process }.to change { Work::Unit.count }.to(10) }
    it { expect { process }.to change { phase.descendants.count }.from(3).to(6) }
    it { expect { process }.to change { child_work_unit.time_entries.sum(:duration) }.from(155).to(15) }


    context "after rebuild" do
      before { process }
      let(:new_work_unit) { phase.descendants.order(id: :desc).where(wuid: '979').first }
      let(:ancestors_wuids) { new_work_unit.ancestors.pluck(:wuid)}

      it { expect(ancestors_wuids).to eq(["ccc", nil, "2-8 Dec '13", "1242", "980"]) }
    end
  end

  def build_context(wuid, name)
    Work::UnitStructureImport::WorkUnitContext.new(wuid, name)
  end

  def create_context_class
    Work::UnitStructureImport::RecreateBasedOnWorkUnitContext
  end
end