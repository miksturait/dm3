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

  let(:tom) { create(:coworker, name: 'Tom Hawk') }
  let(:simon) { create(:coworker, name: 'Simon Walker') }
  let(:tom_time_entries) { Work::TimeImport.new(tom, tom_time_entries_as_text) }
  let(:simon_time_entries) { Work::TimeImport.new(simon, simon_time_entries_as_text) }

  context "Tom workload" do
    let(:import) { tom_time_entries.import! }

    it { expect { import }.to change { Work::TimeEntry.count }.from(0).to(2) }

    context "fully imported" do
      before { import }

      let(:total_workload) { tom.time_entries.sum(:duration) }
      it { expect(total_workload).to eq(135) }

      describe "single time entry" do
        subject(:hrm_time_entry) { tom.time_entries.where(comment: '- coworkers communication').first }
        its(:period_begin) { should eq(Time.parse("2013-11-13	16:00")) }
        its(:period_end) { should eq(Time.parse("2013-11-13	17:00")) }
        its(:duration) { should eq(60) }
      end
    end
  end

  context "Simon workload" do
    let(:import) { simon_time_entries.import! }

    it { expect { import }.to change { Work::TimeEntry.count }.from(0).to(5) }

    context "fully imported" do
      before { import }

      let(:total_workload) { simon.time_entries.sum(:duration) }
      it { expect(total_workload).to eq(750) }

      describe "single time entry" do
        subject(:hrm_time_entry) { simon.time_entries.where(comment: '- topics / blocks').first }
        its(:period_begin) { should eq(Time.parse("2013-11-05	15:00")) }
        its(:period_end) { should eq(Time.parse("2013-11-05	16:30")) }
        its(:duration) { should eq(90) }
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

  describe "Error messages" do
    context "when time entries overlap" do
      let(:time_entries_as_text) do
        %q{
2013-11-11	09:00	09:45	process_and_tools
2013-11-05	15:00	16:30	hrm - topics / blocks
2013-09-02	10:45	11:00	sourcyx-spd-117 writing specs
2013-11-11	09:30	11:00	selleo-1514 working merit money pay
  }
      end

      let(:time_entries) { Work::TimeImport.new(tom, time_entries_as_text) }
      let!(:import) { time_entries.import! }

      it { expect(Work::TimeEntry.count).to eq(0) }
      it { expect(time_entries).to_not be_valid }
      let(:time_entry_with_error) { time_entries.errors.first }
      let(:error_messages) { time_entry_with_error.errors.messages }
      let(:error_messages_for_period) { error_messages[:period] }

      it { expect(time_entry_with_error.comment).to eq('working merit money pay') }
      it { expect(error_messages_for_period).to eq(["overlaps already created record"]) }
    end
    context "when project not defined" do
      let(:time_entries_as_text) do
        %q{
2013-11-11	09:00	09:45	process_and_tools
2013-11-05	15:00	16:30	hrm - topics / blocks
2013-09-02	10:45	11:00	thalamus writing specs
2013-11-11	10:30	11:00	motrono working merit money pay
  }
      end
      let(:time_entries) { Work::TimeImport.new(tom, time_entries_as_text) }
      let(:time_entry_with_error) { time_entries.errors.first }
      let(:error_messages) { time_entry_with_error.errors.messages }
      let(:error_messages_for_work_unit) { error_messages[:work_unit_id] }

      before { time_entries.import! }

      it { expect(Work::TimeEntry.count).to eq(0) }
      it { expect(time_entries).to have(2).error_messages }

      it { expect(time_entry_with_error.comment).to eq('writing specs') }
      it { expect(error_messages_for_work_unit).to eq(["No Project defined with id: thalamus"]) }
    end
  end
end