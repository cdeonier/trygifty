class Vendor < ActiveRecord::Base
  attr_accessible :biz_id, :name, :latitude, :longitude, :foreground_color, :background_color, :facebook_page_id
  
  has_many :items
  has_many :passes
end
