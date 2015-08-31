class RenameMediaAssociation < ActiveRecord::Migration
  def change
    rename_column :media, :notice_id, :media_owner_id
    add_column :media, :media_owner_type, :string
  end
end
