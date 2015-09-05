class AddRelatedNoticesToArray < ActiveRecord::Migration
  def change
    add_column :notices, :related_notices, :text
  end
end
