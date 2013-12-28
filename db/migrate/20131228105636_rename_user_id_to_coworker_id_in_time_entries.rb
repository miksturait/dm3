class RenameUserIdToCoworkerIdInTimeEntries < ActiveRecord::Migration
  def change
    rename_column :time_entries, :user_id, :coworker_id
  end
end
