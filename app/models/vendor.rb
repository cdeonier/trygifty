class Vendor < ActiveRecord::Base
  attr_accessible :biz_id, :name
  
  has_many :items
  has_many :passes
end
