class AddOptsToWorkUnit < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION hstore'
    add_column :work_units, :opts, :hstore
  end
end
