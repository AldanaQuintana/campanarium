class AddKeywordsToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :keywords, :string
  end
end
