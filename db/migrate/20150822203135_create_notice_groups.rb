class CreateNoticeGroups < ActiveRecord::Migration
  def change
    create_table :notice_groups do |t|
      t.timestamps
    end
    add_column :notices, :notice_group_id, :integer
  end
end
