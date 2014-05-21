class AddMeetupsAttendeesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :events_count, :integer, null: false, default: 0
    add_column :users, :attendees_count, :integer, null: false, default: 0
  end
end
