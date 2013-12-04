require 'spec_helper'

describe Work::UnitStructureImport::YouTrackIssue, :vcr do
  let(:youtrack_url) { ENV['YOUTRACK_URL'] }
  let(:youtrack_login) { ENV['YOUTRACK_LOGIN'] }
  let(:youtrack_passwd) { ENV['YOUTRACK_PASSWD'] }
  let(:youtrack) { Work::UnitStructureImport::YouTrackConnection.new(youtrack_url, youtrack_login, youtrack_passwd) }

  subject(:issue) { described_class.new(youtrack, 'selleo-980') }

  let(:sprint) { build_context("2-8 Dec '13", nil) }
  let(:root) { build_context("selleo-1242", "HRM ( recruitment / skills development & dessimination )") }
  let(:children_one) { build_context("selleo-979", "knowledge pack I") }
  let(:children_last) { build_context("selleo-980", "Troubleshooting, The Developer's #1 Skill") }

  its(:work_unit_contexts) { should eq([
                                           sprint,
                                           root,
                                           children_one,
                                           children_last
                                       ]) }

  def build_context(wuid, name)
    Work::UnitStructureImport::YouTrackIssue::Info::WorkUnitContext.new(wuid, name)
  end
end