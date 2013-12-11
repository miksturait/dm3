require 'spec_helper'

describe Work::UnitStructureImport::RecreateBasedOnWorkUnitContext do
  let(:phase) { create(:phase) }

  let(:sprint) { build_context("2-8 Dec '13", nil) }
  let(:root) { build_context("1242", "HRM ( recruitment / skills development & dessimination )") }
  let(:children_one) { build_context("979", "knowledge pack I") }
  let(:children_last) { build_context("980", "Troubleshooting, The Developer's #1 Skill") }
  let(:context) { [sprint, root, children_one, children_last] }

  let(:recreate_based_on_work_unit_context) { described_class.new(phase, context) }
  let(:import) { recreate_based_on_work_unit_context.process }

  context "work unit not defind for current phase" do
    it { expect { import }.to change { phase.descendants.count }.from(0).to(4) }

    context "after import" do
      before { import }

      subject(:last_child) { Work::Unit.last }
      its(:wuid) { should eq '980' }
      its(:name) { should eq %q{Troubleshooting, The Developer's #1 Skill} }

      let(:parent) { last_child.parent }
      it { expect(parent.wuid).to eq '979' }
    end
  end

  context "work unit is partially defined" do
    let!(:sprint_work_unit) { phase.children.create(wuid: "2-8 Dec '13") }
    let!(:child_work_unit) { sprint_work_unit.children.create(wuid: "1242", name: "HRM ( recruitment / skills development & dessimination )") }

    it { expect { import }.to change { phase.descendants.count }.from(2).to(4) }

    context "linking old tree with new" do
      before { import }
      subject(:one_of_the_descendants) { phase.descendants.where(wuid: '979').first }

      its(:parent) { should eq(child_work_unit) }
    end
  end

  def build_context(wuid, name)
    Work::UnitStructureImport::WorkUnitContext.new(wuid, name)
  end
end