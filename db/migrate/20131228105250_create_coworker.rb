class CreateCoworker < ActiveRecord::Migration
  def change
    create_table :coworkers do |t|
      t.string :name
      t.string :email

      t.timestamp
    end
  end
end
