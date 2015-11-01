class AddParentUuidToComments < ActiveRecord::Migration
  def change
    add_column :comments, :parent_uuid, :string
  end
end
