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
end
