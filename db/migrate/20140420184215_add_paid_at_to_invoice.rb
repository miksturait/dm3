class AddPaidAtToInvoice < ActiveRecord::Migration
  def change
    add_column :finance_invoices, :paid_at, :date
  end
end
