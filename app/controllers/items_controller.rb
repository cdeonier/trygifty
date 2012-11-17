class ItemsController < ApplicationController
  http_basic_authenticate_with :name => "gifty-admin", :password => "daikon8chili!", :only => [:index, :destroy, :edit, :update, :create, :new, :show]
  
  def index
    @vendor = Vendor.find(params[:vendor_id])
    @items = @vendor.items
  end

  def show
    @vendor = Vendor.find(params[:vendor_id])
    @item = @vendor.items.find(params[:id])
  end

  def new
    @vendor = Vendor.find(params[:vendor_id])
  end

  def edit
    @vendor = Vendor.find(params[:vendor_id])
    @item = @vendor.items.find(params[:id])
  end

  def create
    @vendor = Vendor.find(params[:vendor_id])
    @item = @vendor.items.create(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to vendor_item_path(@vendor.id, @item), notice: 'Item was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @vendor = Vendor.find(params[:vendor_id])
    @item = @vendor.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:vendor])
        format.html { redirect_to vendor_item_path(@vendor.id, @item), notice: 'Item was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @vendor = Vendor.find(params[:vendor_id])
    @item = @vendor.items.find(params[:id])
    @item.destroy
  end
end
