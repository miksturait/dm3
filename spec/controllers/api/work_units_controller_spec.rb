require 'spec_helper'

describe Api::WorkUnitsController do
  describe 'GET index' do
    subject { JSON.parse(response.body) }

    context 'no work units' do
      let!(:call) { get 'index', format: :json }

      it { should eq [] }
    end

    context 'work unit exists' do
      let!(:now) { Timecop.freeze(Time.utc(2014, 2, 5, 15, 0)); Time.now }
      let!(:now_formatted) { '2014-02-05T15:00:00.000Z' }
      let!(:department_1) { create(:work_unit, name: 'department_1', wuid: 'department_1') }
        let!(:room_1) { create(:work_unit, name: 'room_1', wuid: 'room_1', parent: department_1) }
          let!(:project_a) { create(:project, name: 'project_a', wuid: 'project_a', parent: room_1) }
            let!(:phase_a1) { create(:phase, name: 'phase_a1', parent: project_a) }
            let!(:phase_a2) { create(:phase, name: 'phase_a2', parent: project_a) }
        let!(:room_2) { create(:work_unit, name: 'room_2', wuid: 'room_2', parent: department_1) }
          let!(:project_b) { create(:project, name: 'project_b', wuid: 'project_b', parent: room_2) }
            let!(:phase_b1) { create(:phase, name: 'phase_b1', parent: project_b) }
            let!(:phase_b2) { create(:phase, name: 'phase_b2', parent: project_b) }
      let!(:department_2) { create(:work_unit, name: 'department_2', wuid: 'department_2') }
        let!(:room_3) { create(:work_unit, name: 'room_3', wuid: 'room_3', parent: department_2) }
          let!(:project_c) { create(:project, name: 'project_c', wuid: 'project_c', parent: room_3) }
            let!(:phase_c1) { create(:phase, name: 'phase_c1', parent: project_c) }
            let!(:phase_c2) { create(:phase, name: 'phase_c2', parent: project_c) }
        let!(:room_4) { create(:work_unit, name: 'room_4', wuid: 'room_4', parent: department_2) }
          let!(:project_d) { create(:project, name: 'project_d', wuid: 'project_d', parent: room_4) }
            let!(:phase_d1) { create(:phase, name: 'phase_d1', parent: project_d) }
            let!(:phase_d2) { create(:phase, name: 'phase_d2', parent: project_d) }
      let!(:department_1_json) {
        {
          'id' => department_1.id,
          'wuid' => 'department_1',
          'name' => 'department_1',
          'ancestry' => nil,
          'type' => nil,
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 0
        }
      }
      let!(:room_1_json) {
        {
          'id' => room_1.id,
          'wuid' => 'room_1',
          'name' => 'room_1',
          'ancestry' => "#{department_1.id}",
          'type' => nil,
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 1
        }
      }
      let!(:project_a_json) {
        {
          'id' => project_a.id,
          'wuid' => 'project_a',
          'name' => 'project_a',
          'ancestry' => "#{department_1.id}/#{room_1.id}",
          'type' => 'Project',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 2
        }
      }
      let!(:phase_a1_json) {
        {
          'id' => phase_a1.id,
          'wuid' => nil,
          'name' => 'phase_a1',
          'ancestry' => "#{department_1.id}/#{room_1.id}/#{project_a.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }
      let!(:phase_a2_json) {
        {
          'id' => phase_a2.id,
          'wuid' => nil,
          'name' => 'phase_a2',
          'ancestry' => "#{department_1.id}/#{room_1.id}/#{project_a.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }
      let!(:room_2_json) {
        {
          'id' => room_2.id,
          'wuid' => 'room_2',
          'name' => 'room_2',
          'ancestry' => "#{department_1.id}",
          'type' => nil,
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 1
        }
      }
      let!(:project_b_json) {
        {
          'id' => project_b.id,
          'wuid' => 'project_b',
          'name' => 'project_b',
          'ancestry' => "#{department_1.id}/#{room_2.id}",
          'type' => 'Project',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 2
        }
      }
      let!(:phase_b1_json) {
        {
          'id' => phase_b1.id,
          'wuid' => nil,
          'name' => 'phase_b1',
          'ancestry' => "#{department_1.id}/#{room_2.id}/#{project_b.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }
      let!(:phase_b2_json) {
        {
          'id' => phase_b2.id,
          'wuid' => nil,
          'name' => 'phase_b2',
          'ancestry' => "#{department_1.id}/#{room_2.id}/#{project_b.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }
      let!(:department_2_json) {
        {
          'id' => department_2.id,
          'wuid' => 'department_2',
          'name' => 'department_2',
          'ancestry' => nil,
          'type' => nil,
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 0
        }
      }
      let!(:room_3_json) {
        {
          'id' => room_3.id,
          'wuid' => 'room_3',
          'name' => 'room_3',
          'ancestry' => "#{department_2.id}",
          'type' => nil,
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 1
        }
      }
      let!(:project_c_json) {
        {
          'id' => project_c.id,
          'wuid' => 'project_c',
          'name' => 'project_c',
          'ancestry' => "#{department_2.id}/#{room_3.id}",
          'type' => 'Project',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 2
        }
      }
      let!(:phase_c1_json) {
        {
          'id' => phase_c1.id,
          'wuid' => nil,
          'name' => 'phase_c1',
          'ancestry' => "#{department_2.id}/#{room_3.id}/#{project_c.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }
      let!(:phase_c2_json) {
        {
          'id' => phase_c2.id,
          'wuid' => nil,
          'name' => 'phase_c2',
          'ancestry' => "#{department_2.id}/#{room_3.id}/#{project_c.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }
      let!(:room_4_json) {
        {
          'id' => room_4.id,
          'wuid' => 'room_4',
          'name' => 'room_4',
          'ancestry' => "#{department_2.id}",
          'type' => nil,
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 1
        }
      }
      let!(:project_d_json) {
        {
          'id' => project_d.id,
          'wuid' => 'project_d',
          'name' => 'project_d',
          'ancestry' => "#{department_2.id}/#{room_4.id}",
          'type' => 'Project',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 2
        }
      }
      let!(:phase_d1_json) {
        {
          'id' => phase_d1.id,
          'wuid' => nil,
          'name' => 'phase_d1',
          'ancestry' => "#{department_2.id}/#{room_4.id}/#{project_d.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }
      let!(:phase_d2_json) {
        {
          'id' => phase_d2.id,
          'wuid' => nil,
          'name' => 'phase_d2',
          'ancestry' => "#{department_2.id}/#{room_4.id}/#{project_d.id}",
          'type' => 'Phase',
          'created_at' => now_formatted,
          'updated_at' => now_formatted,
          'period' => nil,
          'opts' => nil,
          'ancestry_depth' => 3
        }
      }

      context 'no filters' do
        let!(:call) { get 'index', format: :json }
        it { should eq [
            department_1_json,
            room_1_json,
            project_a_json,
            phase_a1_json,
            phase_a2_json,
            room_2_json,
            project_b_json,
            phase_b1_json,
            phase_b2_json,
            department_2_json,
            room_3_json,
            project_c_json,
            phase_c1_json,
            phase_c2_json,
            room_4_json,
            project_d_json,
            phase_d1_json,
            phase_d2_json
          ]
        }
      end

      context 'filter with parent work unit' do
        context 'no children' do
          let!(:call) { get 'index', format: :json, parent_work_unit_id: phase_a1.id }
          it { should eq [] }
        end

        context 'one child' do
          let!(:call) { get 'index', format: :json, parent_work_unit_id: room_1.id }
          it { should eq [project_a_json] }
        end

        context 'two children' do
          let!(:call) { get 'index', format: :json, parent_work_unit_id: project_a.id }
          it { should eq [phase_a1_json, phase_a2_json] }
        end
      end

      context 'filter with depth' do
        context 'depth 0' do
          let!(:call) { get 'index', format: :json, depth: 0 }
          it { should eq [department_1_json, department_2_json] }
        end

        context 'depth 1' do
          let!(:call) { get 'index', format: :json, depth: 1 }
          it { should eq [
              department_1_json,
              room_1_json,
              room_2_json,
              department_2_json,
              room_3_json,
              room_4_json
            ]
          }
        end

        context 'depth 2' do
          let!(:call) { get 'index', format: :json, depth: 2 }
          it { should eq [
              department_1_json,
              room_1_json,
              project_a_json,
              room_2_json,
              project_b_json,
              department_2_json,
              room_3_json,
              project_c_json,
              room_4_json,
              project_d_json
            ]
          }
        end
      end
    end
  end
end
