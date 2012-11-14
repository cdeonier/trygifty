class ServiceController < ApplicationController
  def register
    deviceLibraryIdentifier = params[:deviceLibraryIdentifier]
    serialNumber = params[:serialNumber]
    version = params[:version]
    
    pass = Pass.find_by_serial_number(serialNumber)
    
    if request.authorization && request.authorization.include?(' ')
      authenticationToken = request.authorization.split(/\s/)[1]
      if authenticationToken != pass.authentication_token
        puts "*** SERVICE ***: Bad authentication token \"#{authenticationToken}\""
        render :status => 401
      end
    else
      render :status => 401
    end
    
    if version == "v1"
      device = Device.find_by_device_library_identifier(deviceLibraryIdentifier)
      if device
        if device.passes.find_by_serial_number(serialNumber)
          render :status => 200
        else
          device.passes << pass
        end
        
        device.save
      else
        device = Device.new(:device_library_identifier => deviceLibraryIdentifier)
      end
    else
      puts "*** SERVICE ***: Unknown version \"#{version}\""
    end
    
    json = ActiveSupport::JSON.decode(request.body)
    device.push_token = json["pushToken"]
    device.save
    
    render :status => 201
  end
  
  def unregister
  end
  
  def passes
  end
  
  def update
  end
  
  def log
    puts "*** SERVICE LOG ***: "
  end
end
