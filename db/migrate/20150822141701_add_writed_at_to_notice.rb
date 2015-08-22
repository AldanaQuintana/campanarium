class AddWritedAtToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :writed_at, :datetime
  end
end
