class RenameCoworkerTargetTable < ActiveRecord::Migration
  def change
    rename_table :coworker_targets, :targets
  end
end
