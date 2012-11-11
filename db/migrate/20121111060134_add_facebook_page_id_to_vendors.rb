class AddFacebookPageIdToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :facebook_page_id, :string
  end
end
