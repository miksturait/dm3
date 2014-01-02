class CreateWorkCoworkerTarget < ActiveRecord::Migration
  def change
    create_table :coworker_targets do |t|
      t.references :coworker
      t.references :work_unit

      t.integer :hours_per_day, default: 8
      t.daterange :period, defualt: nil

      t.integer :cache_of_total_hours
      t.timestamp
    end
  end
end
