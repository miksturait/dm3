require 'spec_helper'

describe "Importing Work Time Entries" do
  let(:tab_separated_time_entries) {
    %q{
2013-11-18	08:30	09:45	sourcyx-manage
2013-11-13	16:00	17:00	hrm - coworkers communication
2013-11-11	09:00	09:45	process_and_tools
2013-11-05	15:00	16:30	mikstura.it - topics / blocks
2013-09-02	10:45	11:00	sourcyx-ext::spd-117 writing specs
2013-09-15	09:30	17:30	selleo-1514 working merit money pay
    }
  }

  let(:time_entries) {
    Work::TimeEntriesImportFromText.parse(tab_separated_time_entries)
  }

  let(:sourcyx_manage_time_entry) { time_entries.first }
  pending "work unit unfinished" do
    let(:sourcyx_manage_work_unit) { Work::Unit.where(wuid: 'sourcyx-manage') }
  end
  it { expect(sourcyx_manage_time_entry).to eq({
                                                   date: '2013-11-18',
                                                   start_at: '08:30',
                                                   end_at: '09:45',
                                                   work_unit: nil,
                                                   comment: nil
                                               }) }

  let(:sourcyx_spd_117_time_entry) { time_entries[4] }
  it { expect(sourcyx_spd_117_time_entry).to eq({
                                                    date: '2013-09-02',
                                                    start_at: '10:45',
                                                    end_at: '11:00',
                                                    work_unit: nil,
                                                    comment: 'writing specs'
                                                }) }

end