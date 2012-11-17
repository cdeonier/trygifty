require 'apns'

class PassesController < ApplicationController
  http_basic_authenticate_with :name => "gifty-admin", :password => "daikon8chili!", :only => [:index, :destroy, :edit, :update]
  
  def index
    @passes = Pass.all
  end
  
  def destroy
    pass = Pass.find(params[:id])
    vendor = Vendor.find(pass.vendor.id)
    
    AWS::S3::DEFAULT_HOST.replace "s3-us-west-1.amazonaws.com"
    AWS::S3::Base.establish_connection!(
        :access_key_id     => 'AKIAJZORP2CG2ZKHVMJQ',
        :secret_access_key => 'sK+LaL59L8BWY1beskIGBAaLSrjglJB3fw7Oyc2T')
        
    AWS::S3::S3Object.delete "passes/#{vendor.biz_id}/#{pass.serial_number}.pkpass", "gifty"
    
    pass.destroy
    
    redirect_to passes_path
  end
  
  def edit
    @pass = Pass.find(params[:id])
  end
  
  def update
    @pass = Pass.find(params[:id])

    respond_to do |format|
      if @pass.update_attributes(params[:pass])
        format.html { redirect_to passes_path, notice: 'Vendor was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
  def redeem
    @mobile = true
    
    @pass = Pass.find_by_serial_number(params[:serial_number])
    @charge = @pass.charges.build
  end
  
  def redeem_confirmation
    @mobile = true
    
    @pass = Pass.find_by_serial_number(params[:serial_number])
    @charge = Charge.new(params[:charge])
  end
  
  def charged
    @mobile = true
    
    @pass = Pass.find_by_serial_number(params[:serial_number])
    @charge = Charge.new(params[:charge])
    @charge.pass_id = @pass.id
    @charge.save
    
    @pass.amount = @pass.amount - @charge.amount
    @pass.save
    
    APNS.instance.open_connection("production")
    puts "Opening connection to APNS."

    # Get the list of registered devices and send a push notification
    @push_tokens = @pass.devices.collect {|device| device.push_token}.uniq

    @push_tokens.each do |push_token|
      puts "Sending a notification to #{push_token}"
      APNS.instance.deliver(push_token, "{}")
    end

    APNS.instance.close_connection
    puts "APNS connection closed."
    
    Passbook.destroyPass(@pass)
    Passbook.createPass(@pass)
  end
end
