# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :finance_invoice, :class => 'Finance::Invoice' do
    dm2_id 1
    number "MyString"
    customer_name "MyText"
    line_items ""
  end
end
