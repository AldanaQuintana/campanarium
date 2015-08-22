class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :file
      t.integer :notice_id

      t.timestamps null: false
    end
    add_index :media, :notice_id
  end
end
