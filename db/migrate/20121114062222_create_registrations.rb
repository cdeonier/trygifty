class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :device_id
      t.integer :pass_id

      t.timestamps
    end
  end
end
