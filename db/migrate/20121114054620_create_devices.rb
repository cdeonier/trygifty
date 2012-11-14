class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_library_identifier
      t.string :push_token

      t.timestamps
    end
  end
end
