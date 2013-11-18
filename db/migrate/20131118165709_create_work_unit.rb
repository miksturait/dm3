class CreateWorkUnit < ActiveRecord::Migration
  def change
    create_table :work_units do |t|
      t.string :wuid, default: nil
      t.string :name
      t.string :ancestry
      t.string :type

      t.timestamps
    end

    add_index :work_units, :ancestry
  end
end
