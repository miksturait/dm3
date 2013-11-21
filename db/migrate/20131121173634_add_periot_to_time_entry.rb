class AddPeriotToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :period, :tstzrange
    execute(%q{
    CREATE EXTENSION btree_gist;
    ALTER TABLE time_entries
      ADD EXCLUDE USING GIST (user_id WITH =, period WITH &&);
})
  end
end
