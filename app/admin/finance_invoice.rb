ActiveAdmin.register Finance::Invoice, as: 'Invoices' do
  menu parent: "Finance", priority: 5
  actions :index, :show

  filter :number
  filter :customer_name

  index do
    column :number
    column :customer_name
    column :euro
    column :hours_booked, sortable: false
    column :line_items

    actions
  end
end
