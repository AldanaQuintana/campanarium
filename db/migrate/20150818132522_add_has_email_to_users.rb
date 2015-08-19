class AddHasEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_email, :boolean, default: true
  end
end
