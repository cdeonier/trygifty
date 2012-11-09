class AddPassReferenceToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :pass_id, :integer
  end
end
