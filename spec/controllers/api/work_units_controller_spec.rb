require 'spec_helper'

describe Api::WorkUnitsController do
  describe 'GET index' do
    subject { JSON.parse(response.body) }

    context 'no work units' do
      let!(:call) { get 'index', format: :json }

      it { should eq [] }
    end

    context 'work unit exists' do
      context 'no filters' do
        let!(:call) { get 'index', format: :json }
        pending 'TODO'
      end

      context 'filter with parent work unit' do
        let!(:call) { get 'index', format: :json, parent_work_unit_id: 1 }
        pending 'TODO'
      end

      context 'filter with depth' do
        let!(:call) { get 'index', format: :json, depth: 2 }
        pending 'TODO'
      end

      context 'grouping' do
        pending 'TODO'
      end
    end
  end
end
