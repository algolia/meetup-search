class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :member_uid, null: false
      t.string :uid, null: false
      t.text :raw_cache
    end
    add_index :events, :uid
    add_index :events, [:member_uid, :uid]
  end
end
