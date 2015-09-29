class AddCategoriesToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :categories, :string
  end
end
