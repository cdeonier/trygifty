class Transaction < ActiveRecord::Base
  belongs_to :item
  attr_accessible :email, :sender_email, :name, :item_id
end
