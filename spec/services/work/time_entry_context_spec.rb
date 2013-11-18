require 'spec_helper'

describe Work::TimeEntryContext do
  # * it have to always find a project
  # * it have to find or create current phase
  # * within phase find or create work unit - ()if defined)

  context "can't find a project" do
    let(:work_unit) { Work::TimeEntryContext.new('hrm').work_unit }

    it { expect(work_unit).to be_nil }
  end

  context "within project" do

    context "can't find current phase" do

    end

    context "within current phase" do

      context "no work unit defined" do

        it "return current phase as work unit"
      end

      context "can't find work of unit" do

      end

      it "returns work of unit"
    end
  end
end