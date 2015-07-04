class RemoveProvidersFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :providers
  end
end
