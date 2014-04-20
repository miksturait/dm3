class CreateFinanceInvoices < ActiveRecord::Migration
  def change
    create_table :finance_invoices do |t|
      t.integer :dm2_id
      t.string :number
      t.text :customer_name
      t.hstore :line_items
      t.integer :euro

      t.timestamps
    end
  end
end
