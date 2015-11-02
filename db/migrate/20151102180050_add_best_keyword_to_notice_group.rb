class AddBestKeywordToNoticeGroup < ActiveRecord::Migration
  def change
    add_column :notice_groups, :best_keyword, :string
  end
end
