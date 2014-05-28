class AddEventSlug < ActiveRecord::Migration
  def up
    add_column :events, :slug, :string, limit: 32
    add_index :events, :slug
    Event.find_each do |e|
      e.update_attribute :slug, SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
    end
    Event.where(uid: '180093522').update_all slug: '180093522' # backward compat
    change_column :events, :slug, :string, limit: 32, null: false
  end

  def down
    remove_column :events, :slug
    remove_index :events, :slug
  end
end
