class AddReasonsOfDestroyedToUser < ActiveRecord::Migration
  def change
    add_column :users, :reasons_of_destroying, :text
  end
end
