class AddDestroyedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :destroyed_at, :datetime
  end
end
