class Registration < ActiveRecord::Base
  attr_accessible :device_id, :pass_id
  
  belongs_to :device
  belongs_to :pass
end
