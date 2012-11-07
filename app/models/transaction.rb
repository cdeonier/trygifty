class Transaction < ActiveRecord::Base
  belongs_to :item
  attr_accessible :email, :name, :item_id
end
