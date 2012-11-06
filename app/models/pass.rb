class Pass < ActiveRecord::Base
  belongs_to :vendor
  attr_accessible :amount, :serial_number
end
