class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :vendor
      t.decimal :amount

      t.timestamps
    end
    add_index :items, :vendor_id
  end
end
