class Transaction < ActiveRecord::Base
  belongs_to :item
  belongs_to :pass
  attr_accessible :email, :sender_email, :name, :item_id
end
