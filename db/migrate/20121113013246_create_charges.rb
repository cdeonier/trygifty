class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer :pass_id
      t.decimal :amount

      t.timestamps
    end
  end
end
