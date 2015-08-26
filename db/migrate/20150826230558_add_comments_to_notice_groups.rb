class AddCommentsToNoticeGroups < ActiveRecord::Migration
  def change
    add_column :comments, :notice_group_id, :integer
    add_index :comments, :notice_group_id
  end
end
