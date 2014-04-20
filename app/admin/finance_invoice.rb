ActiveAdmin.register Finance::Invoice, as: 'Invoices' do
  menu parent: "Finance", priority: 5
  actions :index, :show

  filter :number
  filter :customer_name
end
