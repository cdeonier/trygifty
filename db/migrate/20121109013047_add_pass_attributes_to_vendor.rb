class AddPassAttributesToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :latitude, :decimal
    add_column :vendors, :longitude, :decimal
    add_column :vendors, :foreground_color, :string
    add_column :vendors, :background_color, :string
  end
end
