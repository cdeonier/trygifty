class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.references :vendor
      t.string :serial_number
      t.decimal :amount

      t.timestamps
    end
    add_index :passes, :vendor_id
  end
end
