class CreateStaticPages < ActiveRecord::Migration
  def up
    create_table :static_pages do |t|
      t.string :title
      t.text :main_content
    end
  end

  def down
    drop_table :static_pages
  end
end
