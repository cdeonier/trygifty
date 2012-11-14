class DevicesController < ApplicationController
  def index
    @devices = Devices.all
  end
end
