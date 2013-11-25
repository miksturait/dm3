require 'spec_helper'

describe Work::TimeEntriesImportFromText do
  context "valid format" do
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
      Work::TimeEntriesImportFromText.new(tab_separated_time_entries)
    }

    describe "work unit id as text" do
      subject(:sourcyx_manage_time_entry) { time_entries.attrs.first }
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
      subject(:sourcyx_spd_117_time_entry) { time_entries.attrs[4] }
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
  end

  describe "handling wrong format" do
    before do
      %w(hrm selleo).each do |wuid|
        create(:project, wuid: wuid)
      end
    end

    context "empty line should be ignored" do
      let(:time_entries_with_error) do
        %q{

2013-11-18	08:30	09:45	selleo-manage

2013-09-15	09:30	17:30	selleo-1514 working merit money pay

    }
      end
      let(:time_entries) { Work::TimeEntriesImportFromText.new(time_entries_with_error) }
      it { expect(time_entries).to have(2).attrs }

      let(:exceptions) { time_entries.attrs.collect { |time_entry_attrs| time_entry_attrs[:exception] }.compact }
      it { expect(exceptions).to be_empty }
    end

    context "lines with wrong format" do
      let(:time_entries_with_error) do
        %q{
2013-11-18	08:30	09:45	selleo-manage
2013-11-13	16:00	     	hrm - coworkers communication
2013-09-15	09:30	17:30	selleo-1514 working merit money pay
    }
      end
      let(:time_entries) { Work::TimeEntriesImportFromText.new(time_entries_with_error) }
      it { expect(time_entries).to have(3).attrs }

      let(:line_with_errors_attr) { time_entries.attrs[1] }
      let(:exception) { line_with_errors_attr[:exception] }
      it { expect(exception).
          to eq({
                    base: [
                        %q{line: "2013-11-13	16:00	     	hrm - coworkers communication" have wrong format}
                    ]
                }) }
    end
  end
end