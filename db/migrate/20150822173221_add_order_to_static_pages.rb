class AddOrderToStaticPages < ActiveRecord::Migration
  def change
    add_column :static_pages, :order, :integer, default: 0
  end
end
