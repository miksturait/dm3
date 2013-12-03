class AddPeriodToWorkUnit < ActiveRecord::Migration
  def change
    add_column :work_units, :period, :daterange
    execute(%q{
    ALTER TABLE work_units
      ADD EXCLUDE USING GIST (ancestry WITH =, period WITH &&);
})
  end
end
