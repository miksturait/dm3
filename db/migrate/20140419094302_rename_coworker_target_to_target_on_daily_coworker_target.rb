class RenameCoworkerTargetToTargetOnDailyCoworkerTarget < ActiveRecord::Migration
  def change
    rename_column :daily_coworker_targets, :coworker_target_id, :target_id
  end
end
