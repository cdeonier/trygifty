class Transaction < ActiveRecord::Base
  belongs_to :item
  attr_accessible :email, :item_id
end
