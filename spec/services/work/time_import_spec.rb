require 'spec_helper'

describe Work::TimeImport do
  let(:tom_time_entries_as_text) do
    %q{
2013-11-18	08:30	09:45	sourcyx-manage
2013-11-13	16:00	17:00	hrm - coworkers communication
}
  end
  let(:simon_time_entries_as_text) do
    %q{
2013-11-11	09:00	09:45	process_and_tools
2013-11-05	15:00	16:30	hrm - topics / blocks
2013-09-02	10:45	11:00	sourcyx-spd-117 writing specs
2013-09-01  10:30 11:00 sourcyx
2013-09-15	09:30	19:00	selleo-1514 working merit money pay
  }
  end

  before do
    %w(sourcyx hrm process_and_tools selleo).each do |wuid|
      create(:project, wuid: wuid)
    end
  end

  let(:tom) { create(:user, name: 'Tom Hawk') }
  let(:simon) { create(:user, name: 'Simon Walker') }
  let(:tom_time_entries) { Work::TimeImport.new(tom, tom_time_entries_as_text) }
  let(:simon_time_entries) { Work::TimeImport.new(simon, simon_time_entries_as_text) }

  context "Tom workload" do
    let(:import) { tom_time_entries.import! }

    it { expect { import }.to change { Work::TimeEntry.count }.from(0).to(2) }

    context "fully imported" do
      before do
        import
      end

      let(:total_workload) { tom.time_entries.sum(:duration) }
      it { expect(total_workload).to eq(135) }

      describe "single time entry" do
        subject(:hrm_time_entry) { tom.time_entries.where(comment: '- coworkers communication').first }
        it { expect(hrm_time_entry.start_at).to eq(DateTime.parse("2013-11-13	16:00")) }
        it { expect(hrm_time_entry.end_at).to eq(DateTime.parse("2013-11-13	17:00")) }
        it { expect(hrm_time_entry.duration).to eq(60) }
      end
    end
  end

  context "Simon workload" do
    let(:import) { simon_time_entries.import! }

    it { expect { import }.to change { Work::TimeEntry.count }.from(0).to(5) }

    context "fully imported" do
      before do
        import
      end
      let(:total_workload) { simon.time_entries.sum(:duration) }
      it { expect(total_workload).to eq(750) }

      describe "single time entry" do
        subject(:hrm_time_entry) { simon.time_entries.where(comment: '- topics / blocks').first }
        it { expect(hrm_time_entry.start_at).to eq(DateTime.parse("2013-11-05	15:00")) }
        it { expect(hrm_time_entry.end_at).to eq(DateTime.parse("2013-11-05	16:30")) }
        it { expect(hrm_time_entry.duration).to eq(90) }
      end
    end
  end

  context "Simon & Tom workload" do
    before do
      simon_time_entries.import!
      tom_time_entries.import!
    end

    let(:sourcyx_project) { Project.where(wuid: 'sourcyx').first }
    let(:sourcyx_workload) { sourcyx_project.time_entries.sum(:duration) }
    it { expect(sourcyx_workload).to eq(120) }
  end

  describe "Exceptions handling" do
    pending "any single exceptions should revert all changes"
    pending "still exceptions should not be rescued"
    pending "safe import should not raise exception"
    pending "and set valid to false, and convert exception to text message for end user"
  end
end