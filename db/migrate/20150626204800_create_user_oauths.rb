class CreateUserOauths < ActiveRecord::Migration
  def change
    create_table(:user_oauths) do |t|
      t.string :uid
      t.string :provider
      t.integer :user_id
      t.timestamps null: false
    end
    add_index :user_oauths, :user_id
  end
end
