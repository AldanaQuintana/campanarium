class AddPositiveIndicatorForComments < ActiveRecord::Migration
  def change
    add_column :comments, :positive, :boolean
  end
end
