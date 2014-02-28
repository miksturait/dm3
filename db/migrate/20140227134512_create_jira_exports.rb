class CreateJiraExports < ActiveRecord::Migration
  def change
    create_table :jira_exports do |t|
      t.integer :time_entry_id
      t.datetime :processed_at
      t.text :last_error

      t.timestamps
    end
  end
end
