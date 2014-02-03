require 'spec_helper'

describe Work::SummaryDataForTree, :focus do
  let(:ccc) { create(:project, name: 'Credit Card Comparison') }
  let(:ccc_sprint) { create(:phase, parent: ccc, name: 'Jan \'14') }
  let(:ccc_work_unit) { create(:work_unit, parent: ccc_sprint, wuid: '145') }
  let(:sourcyx) { create(:project) }
  let(:sourcyx_sprint) { create(:phase, parent: sourcyx) }

  before do
    begin_of_month_period = Time.parse('2014-01-01 14:00')..Time.parse('2014-01-01 16:00')
    end_of_month_period = Time.parse('2014-01-31 17:00')..Time.parse('2014-01-31 19:00')
    last_month_period = Time.parse('2013-12-31 14:00')..Time.parse('2013-12-31 14:30')
    next_month_period = Time.parse('2014-02-01 19:00')..Time.parse('2014-02-01 19:45')

    [end_of_month_period, last_month_period, next_month_period].each do |period|
      create(:time_entry, period: period, work_unit: ccc_sprint)
    end

    [begin_of_month_period].each do |period|
      create(:time_entry, period: period, work_unit: ccc_work_unit)
      create(:time_entry, period: period, work_unit: sourcyx_sprint)
    end
  end

  let(:params) { {start_at: '2014-01-01', end_at: '2014-01-31', project_id: ccc.id} }
  let(:summary) { described_class.new(params) }
  subject { summary.data }

  it { expect(summary.data).
      to eq([
                {:id => ccc.id,
                 :label => ccc.name, :workload => 240},
                {:id => ccc_sprint.id, :parent_id => ccc.id,
                 :label => "Jan '14", :workload => 240},
                {:id => ccc_work_unit.id, :parent_id => ccc_sprint.id,
                 :label => "145", :workload => 120}
            ]) }

  pending 'some optimalisation require for fetching descendants - pick subtree that is relevant for curent period only'
end