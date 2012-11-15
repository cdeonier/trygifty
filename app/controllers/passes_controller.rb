class PassesController < ApplicationController
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
    
    AWS::S3::DEFAULT_HOST.replace "s3-us-west-1.amazonaws.com"
    AWS::S3::Base.establish_connection!(
        :access_key_id     => 'AKIAJZORP2CG2ZKHVMJQ',
        :secret_access_key => 'sK+LaL59L8BWY1beskIGBAaLSrjglJB3fw7Oyc2T')
    @signing_cert = AWS::S3::S3Object.find "secure/storecard_cert.pem", "gifty"
    
    APN = Houston::Client.development
    APN.certificate = @signing_cert.value
    
    @pass.devices.each do |device|
      notification = Houston::Notification.new(device: device.push_token)
      notification.custom_data = {}
      APN.push(notification)
    end
    
  end
end
