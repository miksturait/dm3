class CreateDailyCoworkerTarget < ActiveRecord::Migration
  def change
    create_table :daily_coworker_targets do |t|
      t.references :work_unit
      t.references :coworker
      t.references :coworker_target
      t.date :day
      t.integer :hours

      t.timestamp
    end
  end
end
