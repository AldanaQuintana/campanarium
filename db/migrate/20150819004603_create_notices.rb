class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title
      t.text :body
      t.string :source
      t.string :url

      t.timestamps null: false
    end
  end
end
