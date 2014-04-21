FactoryGirl.define do
  sequence :uniqid do |n|
    n
  end

  factory :finance_invoice, :class => 'Finance::Invoice' do
    dm2_id { generate(:uniqid) }
    number { "#{generate(:uniqid)} / #{Time.now.year}"}
    customer_name { "Some Customer [#{generate(:uniqid)}]" }
    euro { rand(10000) + 2000 }
    paid_at nil
  end
end
