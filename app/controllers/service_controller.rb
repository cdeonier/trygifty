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

    @device = Device.find_by_device_library_identifier(params[:deviceLibraryIdentifier])

    @registration = Registration.find_by_device_id_and_pass_id(@device.id, @pass.id)
    head :not_found and return if @registration.nil?

    @registration.destroy
    
    Device.all.each do |device|
      device.registrations.each do |registration|
        registration.destroy
      end
      device.destroy
    end
    
    # if @device.registrations.empty?
    #       @device.destroy
    #     end

    head :ok
  end
  
  def passes    
    device = Device.find_by_device_library_identifier(params[:deviceLibraryIdentifier])
    
    head :not_found and return if device.nil? || device.passes.nil?

    if params[:passesUpdatedSince]
      @passes = device.passes.where('passes.updated_at > ?', params[:passesUpdatedSince]) 
    else
      @passes = device.passes
    end

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
      AWS::S3::DEFAULT_HOST.replace "s3-us-west-1.amazonaws.com"
      AWS::S3::Base.establish_connection!(
          :access_key_id     => 'AKIAJZORP2CG2ZKHVMJQ',
          :secret_access_key => 'sK+LaL59L8BWY1beskIGBAaLSrjglJB3fw7Oyc2T')

      vendor = Vendor.find(@pass.vendor_id)

      pkpass = AWS::S3::S3Object.find "passes/#{@pass.vendor.biz_id}/#{@pass.serial_number}.pkpass", "gifty"
      send_data(pkpass.value)
    else
      head :not_modified
    end
  end
  
  def log
    json = ActiveSupport::JSON.decode(request.body)
    logs = json["logs"]
    logs.each do |log|
      puts log
    end
    
    head :ok
  end
end
