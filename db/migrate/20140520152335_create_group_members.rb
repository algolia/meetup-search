class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.integer :gid, null: false
      t.integer :uid, null: false
      t.text :raw_cache
    end
    add_index :group_members, [:gid, :uid]
  end
end
