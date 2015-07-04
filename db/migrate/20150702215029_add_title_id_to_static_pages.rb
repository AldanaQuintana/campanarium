class AddTitleIdToStaticPages < ActiveRecord::Migration
  def change
    add_column :static_pages, :title_identifier, :string
  end
end
