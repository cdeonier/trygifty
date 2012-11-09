class AddItemIdToPass < ActiveRecord::Migration
  def change
    add_column :passes, :item_id, :integer
  end
end
