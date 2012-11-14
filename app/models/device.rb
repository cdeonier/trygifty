class Device < ActiveRecord::Base
  attr_accessible :device_library_identifier, :push_token
  
  has_many :registrations
  has_many :passes, :through => :registrations
end
