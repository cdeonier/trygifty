class AddSenderNameToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :sender_name, :string
  end
end
