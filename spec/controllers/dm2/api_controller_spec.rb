require 'spec_helper'

describe Dm2::ApiController do

  describe "GET 'workload_import'" do
    context "failure" do
      let!(:call) {
        get 'workload_import', {
            auth_token: '9552211f1ac89d0bb10863a71a92',
            import: {
                coworker_email: 'some@email.com',
                time_entries_data: ''
            }
        }
      }
      subject(:return_message) { JSON.parse(response.body) }

      it { should eq({"errors" => ["ActiveRecord::RecordNotFound",
                                   "{:params=>{\"coworker_email\"=>\"some@email.com\", \"time_entries_data\"=>\"\"}}"],
                      "time_entries" => [],
                      "time_entries_data" => nil}) }
      it { expect(Work::TimeEntry.count).to eq(0) }
    end

    context "success" do
      let!(:coworker) { create(:coworker, email: 'simon@mikstura.it') }
      let!(:work_unit) { create(:project, wuid: 'hrm') }

      let!(:call) {
        get 'workload_import', {
            auth_token: '9552211f1ac89d0bb10863a71a92',
            import: {
                coworker_email: 'simon@mikstura.it',
                time_entries_data: %q{
2013-11-18	08:30	09:45	hrm - 360 feedback session
2013-11-13	16:00	17:00	hrm - coworkers communication
}
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

  describe "GET 'statistics'", :focus do
    let(:simon) { create(:coworker, email: 'simon@mikstura.it') }
    let(:project) { create(:project, name: 'Global Sourcing Platform') }
    let(:work_unit) { create(:phase, parent: project) }
    before do
      Timecop.freeze(Time.local(2014, 1, 9))
      create(:time_entry, coworker: simon, period: Time.now..(Time.now+5.hours), work_unit: work_unit)
      create(:time_entry, coworker: simon, period: (Time.now-7.days)..(Time.now-7.days+3.hours+5.minutes), work_unit: work_unit)
      create(:time_entry, coworker: simon, period: (Time.now-14.days)..(Time.now-14.days+7.hours+15.minutes), work_unit: work_unit)

      create(:coworker_target, coworker: simon, work_unit: work_unit, period: Date.today-8.days..Date.today-7.days)
      create(:coworker_target, coworker: simon, work_unit: work_unit, period: Date.today-3.days..Date.today-3.days)
    end
    let!(:call) {
      get 'statistics', {
          auth_token: '9552211f1ac89d0bb10863a71a92',
          statistics: {
              coworker_email: 'simon@mikstura.it'
          }
      }
    }

    subject(:return_message) { JSON.parse(response.body) }

    it { should eq({
                       "personal" => {
                           "this_week" => {
                               "total" => {
                                   "worked" => 300,
                                   "target" => 8,
                                   "available" => 40
                               },
                               "Global Sourcing Platform" => {
                                   "worked" => 300,
                                   "target" => 1*8
                               }
                           },
                           "this_month" => {
                               "total" => {
                                   "worked" => 485,
                                   "target" => 3*8,
                                   "available" => 184
                               },
                               "Global Sourcing Platform" => {
                                   "worked" => 485,
                                   "target" => 3*8
                               }
                           },
                           "last_month" => {
                               "total" => {
                                   "worked" => 435,
                                   "target" => 0,
                                   "available" => 176
                               },
                               "Global Sourcing Platform" => {
                                   "worked" => 435,
                                   "target" => 0
                               }
                           }
                       },
                       "team" => {
                           "this_week"=>{},
                           "this_month"=>{},
                           "last_month"=>{}}
                   }) }
  end
end
