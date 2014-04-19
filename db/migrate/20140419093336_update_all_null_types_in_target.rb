class UpdateAllNullTypesInTarget < ActiveRecord::Migration
  def up
    Work::Target.where(type: nil).update_all(type: 'Work::CoworkerTarget')
  end
end
