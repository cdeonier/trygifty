class AddSenderEmailToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :sender_email, :string
  end
end
