require 'spec_helper'

describe Api::CoworkersController do
  describe 'GET index' do
    subject { JSON.parse(response.body) }

    context 'no coworkers' do
      let!(:call) { get 'index', format: :json }

      it { should eq [] }
    end

    context 'coworkers exist' do
      let!(:coworker_1) { create(:coworker, email: '1@mikstura.it', name: 'one') }
      let!(:coworker_2) { create(:coworker, email: '2@mikstura.it', name: 'two') }
      let!(:coworker_1_json) {
        {
          'id' => coworker_1.id,
          'name' => 'one',
          'email' => '1@mikstura.it'
        }
      }
      let!(:coworker_2_json) {
        {
          'id' => coworker_2.id,
          'name' => 'two',
          'email' => '2@mikstura.it'
        }
      }
      let!(:call) { get 'index', format: :json }
      it { should eq [coworker_1_json, coworker_2_json] }
    end
  end
end
