# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :jira_export, class: 'Jira::Export' do
    time_entry_id 1
    processed_at "2014-02-27 14:45:12"
  end
end
