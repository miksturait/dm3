class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.belongs_to :user
      t.belongs_to :work_unit
      t.datetime :start_at
      t.datetime :end_at
      t.integer :duration
      t.text :comment
    end

    add_index :time_entries, :user_id
    add_index :time_entries, :work_unit_id
  end
end
