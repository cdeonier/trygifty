class VendorsController < ApplicationController
  http_basic_authenticate_with :name => "gifty-admin", :password => "daikon8chili!", :only => [:index, :destroy, :edit, :update, :create, :new, :show]
  
  def index
    @vendors = Vendor.all
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def new
    @vendor = Vendor.new
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def create
    @vendor = Vendor.new(params[:vendor])

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to @vendor, notice: 'Vendor was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to @vendor, notice: 'Vendor was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
  end
  
  def store
    @vendor = Vendor.find_by_biz_id(params[:biz_id])
    @items = @vendor.items
  end
  
  def facebook
    signed_request = params[:signed_request]
    @signed_request = decode_data(signed_request)

    facebook_page_id = @signed_request["page"]["id"]
    vendor = Vendor.find_by_facebook_page_id(facebook_page_id)
    
    redirect_to store_path(vendor.biz_id)
  end
  
  def base64_url_decode str
   encoded_str = str.gsub('-','+').gsub('_','/')
   encoded_str += '=' while !(encoded_str.size % 4).zero?
   Base64.decode64(encoded_str)
  end

  def decode_data str
   encoded_sig, payload = str.split('.')
   data = ActiveSupport::JSON.decode base64_url_decode(payload)
  end
end
