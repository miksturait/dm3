require 'spec_helper'

describe Work::TimeEntriesImportFromText do
  let(:tab_separated_time_entries) do
    %q{
2013-11-18	08:30	09:45	sourcyx-manage
2013-11-13	16:00	17:00	hrm - coworkers communication
2013-11-11	09:00	09:45	process_and_tools
2013-11-05	15:00	16:30	mikstura.it - topics / blocks
2013-09-02	10:45	11:00	sourcyx-spd-117 writing specs
2013-09-15	09:30	17:30	selleo-1514 working merit money pay
    }
  end

  before do
    %w(hrm process_and_tools mikstura.it selleo).each do |wuid|
      create(:project, wuid: wuid)
    end
  end
  let!(:sourcyx_project) { create(:project, wuid: 'sourcyx') }
  let(:sourcyx_active_phase) { sourcyx_project.active_phase }
  let!(:time_entries) {
    Work::TimeEntriesImportFromText.parse(tab_separated_time_entries)
  }

  describe "work unit id as text" do
    subject(:sourcyx_manage_time_entry) { time_entries.first }
    let(:sourcyx_manage_work_unit) { sourcyx_active_phase.units.where(wuid: 'manage').first }
    let(:time_entry_start_at) { Time.parse("2013-11-18 08:30") }
    let(:time_entry_end_at) { Time.parse("2013-11-18 09:45") }
    it { expect(sourcyx_manage_time_entry).
        to eq({
                  period: time_entry_start_at..time_entry_end_at,
                  work_unit: sourcyx_manage_work_unit,
                  comment: nil,
                  exception: nil
              }) }
  end

  describe "work unit id as number" do
    subject(:sourcyx_spd_117_time_entry) { time_entries[4] }
    let(:sourcyx_spd_117_work_unit) { sourcyx_active_phase.units.where(wuid: 'spd-117').first }
    let(:time_entry_start_at) { Time.parse("2013-09-02 10:45") }
    let(:time_entry_end_at) { Time.parse("2013-09-02 11:00") }
    it { expect(sourcyx_spd_117_time_entry).
        to eq({
                  period: time_entry_start_at..time_entry_end_at,
                  work_unit: sourcyx_spd_117_work_unit,
                  comment: 'writing specs',
                  exception: nil
              }) }
  end

  pending 'for each unprocessable line raise custom exception with information about line and the reason'
end