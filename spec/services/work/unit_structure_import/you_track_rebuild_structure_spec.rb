require 'spec_helper'

describe Work::UnitStructureImport::YouTrackRebuildStructure do

  let(:phase) { create(:phase) }
  let(:other_phase) { create(:phase) }
  let(:some_work_unit) { other_phase.create_children(wuid: '4533') }
  # TODO refactor without using create_context_class & build_context
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

  describe "#work_units", :focus do
    let(:work_units_map) { youtrack_rebuild_structure.work_units_map }

    it { expect(work_units_map).
        to eq({
                  child_work_unit => child_work_unit.time_entries.within_period(period).pluck(:id),
                  a_good_child_work_unit => a_good_child_work_unit.time_entries.within_period(period).pluck(:id)
              })
    }

  end
  # work_unit_id / data_period

  # find all work_units for time entries in that period
  # keep work_unit_id => time_entries_ids

  context "different ancestors structure and different name of ticket" do
    let(:root) { build_context("1242", "HRM ( recruitment / skills development & dessimination )") }
    let(:group) { build_context("980", "Troubleshooting, The Developer's #1 Skill") }
    let(:child) { sprint.children.create("979", "some new name") }
    let(:new_context) { [sprint, root, group, child] }


    # for each work unit
    #   * recreate work_unit_structure
    #   * if work unit is brand new update time_entries
  end

  def build_context(wuid, name)
    Work::UnitStructureImport::WorkUnitContext.new(wuid, name)
  end

  def create_context_class
    Work::UnitStructureImport::RecreateBasedOnWorkUnitContext
  end
end