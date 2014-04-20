class AddTargetBelongsToInvoice < ActiveRecord::Migration
  def change
    add_column :targets, :invoice_id, :integer
  end
end
