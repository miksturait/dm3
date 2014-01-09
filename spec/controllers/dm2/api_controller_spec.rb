require 'spec_helper'

describe Dm2::ApiController do

  describe "GET 'workload_import'" do
    context "failure" do
      let!(:call) {
        post 'workload_import', {
            auth_token: '',
            coworker_email: 'some@email.com',
            time_entries_data: ''
        }
      }
      subject(:return_message) { JSON.parse(response.body) }

      it { should eq({"errors" => ["undefined method `[]' for nil:NilClass",
                                   "{:params=>nil}"],
                      "time_entries" => [],
                      "time_entries_data" => nil}) }
      it { expect(Work::TimeEntry.count).to eq(0) }
    end

    context "success" do
      let!(:coworker) { create(:coworker, email: 'simon@mikstura.it') }
      let!(:work_unit) { create(:project, wuid: 'hrm') }

      let!(:call) {
        post 'workload_import', import: {
            auth_token: '9552211f1ac89d0bb10863a71a92',
            coworker_email: 'simon@mikstura.it',
            time_entries_data: %q{
2013-11-18	08:30	09:45	hrm - 360 feedback session
2013-11-13	16:00	17:00	hrm - coworkers communication
}
        }
      }
      subject(:return_message) { JSON.parse(response.body) }

      it { should eq({
                         "errors" => [],
                         "time_entries" => ["  75 minutes on      : 2014-01-06 [- 360 feedback session]", "  60 minutes on      : 2014-01-06 [- coworkers communication]"],
                         "time_entries_data" => "\n2013-11-18\t08:30\t09:45\thrm - 360 feedback session\n2013-11-13\t16:00\t17:00\thrm - coworkers communication\n"}) }
    end
  end
end
