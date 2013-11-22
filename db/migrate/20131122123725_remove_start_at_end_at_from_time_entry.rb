class RemoveStartAtEndAtFromTimeEntry < ActiveRecord::Migration
  def change
    remove_column :time_entries, :start_at
    remove_column :time_entries, :end_at
  end
end
