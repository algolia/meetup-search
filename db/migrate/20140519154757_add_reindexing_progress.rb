class AddReindexingProgress < ActiveRecord::Migration
  def change
    add_column :users, :reindexing_progress, :integer, null: false, default: 0
  end
end
