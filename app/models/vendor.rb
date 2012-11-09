class Vendor < ActiveRecord::Base
  attr_accessible :biz_id, :name, :latitude, :longitude, :foreground_color, :background_color
  
  has_many :items
  has_many :passes
end
