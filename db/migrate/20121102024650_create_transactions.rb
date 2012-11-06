class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :item
      t.string :email

      t.timestamps
    end
    add_index :transactions, :item_id
  end
end
