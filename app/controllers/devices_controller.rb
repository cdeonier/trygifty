class DevicesController < ApplicationController
  http_basic_authenticate_with :name => "gifty-admin", :password => "daikon8chili!", :only => [:index]
  
  def index
    @devices = Device.all
  end
end
