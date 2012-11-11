class Transaction < ActiveRecord::Base
  belongs_to :item
  belongs_to :pass
  attr_accessible :email, :name, :sender_email, :sender_name, :item_id
end
