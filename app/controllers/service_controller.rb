class ServiceController < ApplicationController
  respond_to :json
  
  #Most code from mattt/passbook_rails_example on github
  
  def register
    @pass = Pass.find_by_serial_number(params[:serialNumber])
    head :not_found and return if @pass.nil?
    head :unauthorized and return if request.env['HTTP_AUTHORIZATION'] != "ApplePass #{@pass.authentication_token}"

    @device = Device.where(:device_library_identifier => params[:deviceLibraryIdentifier]).first_or_initialize
    @device.push_token = params[:pushToken]

    status = @device.new_record? ? :created : :ok

    @device.save
    
    @registration = Registration.where(:device_id => @device.id, :pass_id => @pass.id).first_or_create

    head status
  end
  
  def unregister
    @pass = Pass.find_by_serial_number(params[:serialNumber])
    head :not_found and return if @pass.nil?
    head :unauthorized and return if request.env['HTTP_AUTHORIZATION'] != "ApplePass #{@pass.authentication_token}"

    @device = Device.find_by_device_Library_identifier(params[:deviceLibraryIdentifier])

    @registration = Registration.find_by_device_id_and_pass_id(@device.id, @pass.id)
    head :not_found and return if @registration.nil?

    @registration.destroy

    head :ok
  end
  
  def passes    
    device = Device.find_by_device_library_identifier(params[:deviceLibraryIdentifier])
    
    head :not_found and return if device.passes.empty?

    @passes = device.passes.where('passes.updated_at > ?', params[:passesUpdatedSince]) if params[:passesUpdatedSince]

    if @passes.any?
      respond_with({
        lastUpdated: @passes.collect(&:updated_at).max,
        serialNumbers: @passes.collect(&:serial_number).collect(&:to_s)
      })
    else
      head :no_content
    end
  end
  
  def update
    @pass = Pass.find_by_serial_number(params[:serialNumber])
    head :not_found and return if @pass.nil?
    head :unauthorized and return if request.env['HTTP_AUTHORIZATION'] != "ApplePass #{@pass.authentication_token}"

    if stale?(last_modified: @pass.updated_at.utc)
      respond_with @pass
    else
      head :not_modified
    end
  end
  
  def log
    log_file = Logger.new("#{Rails.root}/log/apple.log")
    log_file.info("        **** Web Service Error ****         ")
    json = ActiveSupport::JSON.decode(request.body)
    logs = json["logs"]
    logs.each do |log|
      log_file.info
    end
    
    head :ok
  end
end
