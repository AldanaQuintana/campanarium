class AddPolarityToCommentsAndRemovePositive < ActiveRecord::Migration
  def change
    remove_column :comments, :positive, :boolean
    add_column :comments, :polarity, :integer
    add_column :comments, :positivity, :string
  end
end
