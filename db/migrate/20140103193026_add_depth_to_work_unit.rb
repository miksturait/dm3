class AddDepthToWorkUnit < ActiveRecord::Migration
  def change
    add_column :work_units, :ancestry_depth, :integer, default: 0
  end
end
