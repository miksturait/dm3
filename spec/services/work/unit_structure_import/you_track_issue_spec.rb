require 'spec_helper'

describe Work::UnitStructureImport::YouTrackIssue, :vcr do
  let(:youtrack_config) { Work::UnitStructureImport::YouTrackConfig.new.attrs }
  let(:youtrack) { Work::UnitStructureImport::YouTrackConnection.new(youtrack_config) }

  let(:sprint) { build_context("2-8 Dec '13", nil) }
  let(:root) { build_context("1242", "HRM ( recruitment / skills development & dessimination )") }
  let(:children_one) { build_context("979", "knowledge pack I") }
  let(:children_last) { build_context("980", "Troubleshooting, The Developer's #1 Skill") }

  subject(:issue) { described_class.new(youtrack, 'selleo-980') }

  its(:work_unit_contexts) { should eq([
                                           sprint,
                                           root,
                                           children_one,
                                           children_last
                                       ]) }

  def build_context(wuid, name)
    Work::UnitStructureImport::WorkUnitContext.new(wuid, name)
  end
end