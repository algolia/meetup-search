class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :uid, null: false
      t.text :raw_cache
    end
    add_index :members, :uid
  end
end
