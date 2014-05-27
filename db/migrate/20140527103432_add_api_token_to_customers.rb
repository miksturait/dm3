class AddApiTokenToCustomers < ActiveRecord::Migration
  def up
    add_column :work_units, :api_token, :string
    Customer.all.each { |customer| customer.send(:set_api_token) }
  end

  def down
    remove_column :work_units, :api_token
  end
end
