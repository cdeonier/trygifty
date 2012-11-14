class Charge < ActiveRecord::Base
  attr_accessible :amount, :pass_id
  
  belongs_to :pass
end
