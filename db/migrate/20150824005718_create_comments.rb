class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :source
      t.text :message
      t.string :username
      t.string :uuid
    end
  end
end
