class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :biz_id
      t.string :name

      t.timestamps
    end
  end
end
