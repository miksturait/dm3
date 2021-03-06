require 'spec_helper'

describe Api::WorkEntriesController do
  describe 'GET index' do
    subject { JSON.parse(response.body) }

    context 'no work entries' do
      let!(:call) { get 'index', format: :json }

      it { should eq [] }
    end

    context 'work entries exist' do
      let!(:now) { Timecop.freeze(Time.utc(2014, 2, 5, 15, 0)); Time.now }
      let!(:coworker_1) { create(:coworker, email: '1@mikstura.it', name: 'one') }
      let!(:coworker_2) { create(:coworker, email: '2@mikstura.it', name: 'two') }
      let!(:coworker_3) { create(:coworker, email: '3@mikstura.it', name: 'three') }
      let!(:project) { create(:project, name: 'Project #1') }
      let!(:work_unit_1) { create(:phase, parent: project) }
      let!(:work_unit_2) { create(:phase, parent: project) }
      let!(:work_entry_1) { create(:time_entry, work_unit: work_unit_1, coworker: coworker_1, comment: 'a', period: (now..now + 5.minutes)) }
      let!(:work_entry_2) { create(:time_entry, work_unit: work_unit_1, coworker: coworker_2, comment: 'b', period: (now - 5.minutes..now)) }
      let!(:work_entry_3) { create(:time_entry, work_unit: work_unit_2, coworker: coworker_3, comment: 'c', period: (now - 1.minute..now + 1.minute)) }
      let!(:work_entry_1_json) {
        {
          'id' => work_entry_1.id,
          'work_unit_id' => work_unit_1.id,
          'coworker_id' => coworker_1.id,
          'start_time' => '2014-02-05T15:00:00Z',
          'end_time' => '2014-02-05T15:05:00Z',
          'duration' => 5,
          'coworker_name' => 'one',
          'comment' => 'a',
        }
      }
      let!(:work_entry_2_json) {
        {
          'id' => work_entry_2.id,
          'work_unit_id' => work_unit_1.id,
          'coworker_id' => coworker_2.id,
          'start_time' => '2014-02-05T14:55:00Z',
          'end_time' => '2014-02-05T15:00:00Z',
          'duration' => 5,
          'coworker_name' => 'two',
          'comment' => 'b',
        }
      }
      let!(:work_entry_3_json) {
        {
          'id' => work_entry_3.id,
          'work_unit_id' => work_unit_2.id,
          'coworker_id' => coworker_3.id,
          'start_time' => '2014-02-05T14:59:00Z',
          'end_time' => '2014-02-05T15:01:00Z',
          'duration' => 2,
          'coworker_name' => 'three',
          'comment' => 'c',
        }
      }

      context 'no filters' do
        let!(:call) { get 'index', format: :json }
        it { should eq [work_entry_1_json, work_entry_2_json, work_entry_3_json] }
      end

      context 'pagination' do
        context 'page 1' do
          let!(:call) { get 'index', format: :json, page: 1, limit: 2 }
          it { should eq [work_entry_1_json, work_entry_2_json] }
        end

        context 'page 2' do
          let!(:call) { get 'index', format: :json, page: 2, limit: 2 }
          it { should eq [work_entry_3_json] }
        end

        context 'page 3' do
          let!(:call) { get 'index', format: :json, page: 3, limit: 2 }
          it { should eq [] }
        end
      end

      context 'filter with coworkers' do
        let!(:call) { get 'index', format: :json, coworker_ids: [coworker_1.id, coworker_2.id] }
        it { should eq [work_entry_1_json, work_entry_2_json] }
      end

      context 'filter with work unit' do
        let!(:call) { get 'index', format: :json, work_unit_id: work_unit_2.id }
        it { should eq [work_entry_3_json] }
      end

      context 'filter with after' do
        let!(:call) { get 'index', format: :json, after: '2014-02-05T14:59Z' }
        it { should eq [work_entry_1_json, work_entry_3_json] }
      end

      context 'filter with before' do
        let!(:call) { get 'index', format: :json, before: '2014-02-05T14:58Z' }
        it { should eq [work_entry_2_json] }
      end

      context 'filter with after and before' do
        context 'one matching entry' do
          let!(:call) { get 'index', format: :json, after: '2014-02-05T14:59Z', before: '2014-02-05T14:59Z' }
          it { should eq [work_entry_3_json] }
        end

        context 'two matching entries' do
          let!(:call) { get 'index', format: :json, after: '2014-02-05T14:59Z', before: '2014-02-05T15:01Z' }
          it { should eq [work_entry_1_json, work_entry_3_json] }
        end

        context 'mutually excluded entries' do
          let!(:call) { get 'index', format: :json, after: '2014-02-05T15:00Z', before: '2014-02-05T14:59Z' }
          it { should eq [] }
        end
      end

      context 'filter with multi criteria' do
        context 'one matching entry' do
          let!(:call) { get 'index', format: :json, after: '2014-02-05T14:59Z', coworker_ids: [coworker_3.id], work_unit_id: work_unit_2.id }
          it { should eq [work_entry_3_json] }
        end

        context 'no matching entry' do
          let!(:call) { get 'index', format: :json, after: '2014-02-05T14:59Z', coworker_ids: [coworker_3.id], work_unit_id: work_unit_1.id }
          it { should eq [] }
        end
      end

      context 'grouping' do
        let(:beginning_of_day) { '2014-02-05T00:00:00Z' }
        let(:beginning_of_week) { '2014-02-03T00:00:00Z' }
        let(:beginning_of_month) { '2014-02-01T00:00:00Z' }

        context 'group by day' do
          let!(:call) { get 'index', format: :json, group_by: %w(day) }
          it { should eq({
              beginning_of_day => [work_entry_1_json, work_entry_2_json, work_entry_3_json]
            })
          }
        end

        context 'group by week' do
          let!(:call) { get 'index', format: :json, group_by: %w(week) }
          it { should eq({
              beginning_of_week => [work_entry_1_json, work_entry_2_json, work_entry_3_json]
            })
          }
        end

        context 'group by month' do
          let!(:call) { get 'index', format: :json, group_by: %w(month) }
          it { should eq({
              beginning_of_month => [work_entry_1_json, work_entry_2_json, work_entry_3_json]
            })
          }
        end

        context 'group by coworker' do
          let!(:call) { get 'index', format: :json, group_by: %w(coworker) }
          it { should eq({
              coworker_1.id.to_s => [work_entry_1_json],
              coworker_2.id.to_s => [work_entry_2_json],
              coworker_3.id.to_s => [work_entry_3_json]
            })
          }
        end

        context 'group by day and coworker' do
          let!(:call) { get 'index', format: :json, group_by: %w(day coworker) }
          it { should eq({
              beginning_of_day => {
                coworker_1.id.to_s => [work_entry_1_json],
                coworker_2.id.to_s => [work_entry_2_json],
                coworker_3.id.to_s => [work_entry_3_json]
              }
            })
          }
        end

        context 'group by week and coworker' do
          let!(:call) { get 'index', format: :json, group_by: %w(week coworker) }
          it { should eq({
              beginning_of_week => {
                coworker_1.id.to_s => [work_entry_1_json],
                coworker_2.id.to_s => [work_entry_2_json],
                coworker_3.id.to_s => [work_entry_3_json]
              }
            })
          }
        end

        context 'group by month and coworker' do
          let!(:call) { get 'index', format: :json, group_by: %w(month coworker) }
          it { should eq({
              beginning_of_month => {
                coworker_1.id.to_s => [work_entry_1_json],
                coworker_2.id.to_s => [work_entry_2_json],
                coworker_3.id.to_s => [work_entry_3_json]
              }
            })
          }
        end

        context 'group by coworker and day' do
          let!(:call) { get 'index', format: :json, group_by: %w(coworker day) }
          it { should eq({
              coworker_1.id.to_s => {
                beginning_of_day => [work_entry_1_json]
              },
              coworker_2.id.to_s => {
                beginning_of_day => [work_entry_2_json]
              },
              coworker_3.id.to_s => {
                beginning_of_day => [work_entry_3_json]
              }
            })
          }
        end

        context 'group by coworker and week' do
          let!(:call) { get 'index', format: :json, group_by: %w(coworker week) }
          it { should eq({
              coworker_1.id.to_s => {
                beginning_of_week => [work_entry_1_json]
              },
              coworker_2.id.to_s => {
                beginning_of_week => [work_entry_2_json]
              },
              coworker_3.id.to_s => {
                beginning_of_week => [work_entry_3_json]
              }
            })
          }
        end

        context 'group by coworker and month' do
          let!(:call) { get 'index', format: :json, group_by: %w(coworker month) }
          it { should eq({
              coworker_1.id.to_s => {
                beginning_of_month => [work_entry_1_json]
              },
              coworker_2.id.to_s => {
                beginning_of_month => [work_entry_2_json]
              },
              coworker_3.id.to_s => {
                beginning_of_month => [work_entry_3_json]
              }
            })
          }
        end

        context 'invalid grouping' do
          subject { response }

          context 'non existed parameters' do
            let!(:call) { get 'index', format: :json, group_by: %w(coworker bla-bla) }
            its(:status) { should eq 422 }
          end

          context 'duplicated group by' do
            let!(:call) { get 'index', format: :json, group_by: %w(coworker coworker) }
            its(:status) { should eq 422 }
          end

          context 'too much parameters' do
            let!(:call) { get 'index', format: :json, group_by: %w(coworker day month) }
            its(:status) { should eq 422 }
          end

          context 'combined dates' do
            let!(:call) { get 'index', format: :json, group_by: %w(day week) }
            its(:status) { should eq 422 }
          end
        end
      end
    end
  end
end
