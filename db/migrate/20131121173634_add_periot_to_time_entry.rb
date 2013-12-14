class AddPeriotToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :period, :tstzrange
    enable_extension(:btree_gist)
#    TODO: don't know how to set this index to be inclusive
#    execute(%q{
#    CREATE EXTENSION btree_gist;
#    ALTER TABLE time_entries
#      ADD EXCLUDE USING GIST (user_id WITH =, period WITH &&);
#})
  end
end
