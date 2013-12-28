class CreateDaysOffPeriod < ActiveRecord::Migration
  def change
    create_table :days_off_periods do |t|
      t.references :coworker
      t.daterange :period
      t.string :comment

      t.timestamp
    end
  end
end
