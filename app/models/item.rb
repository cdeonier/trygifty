class Item < ActiveRecord::Base
  attr_accessible :amount
  belongs_to :vendor
  has_many :transactions
  has_many :passes
end
