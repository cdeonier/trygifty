class OrderMailer < ActionMailer::Base
  default :from => "Gifty <orders@trygifty.com>"
  default :reply_to => "Christian Deonier <cdeonier@trygifty.com>"
  
  def order_notification(pass)
    @pass = pass
    @vendor = Vendor.find(@pass.vendor_id)
    @transaction = @pass.transaction
    mail(:to => "#{@transaction.name} <#{@transaction.email}>", :subject => "You were sent a gift card for #{@vendor.name}!")
  end
  
  def order_confirmation(pass)
    @pass = pass
    @vendor = Vendor.find(@pass.vendor_id)
    @transaction = @pass.transaction
    mail(:to => "#{@transaction.sender_name} <#{@transaction.sender_email}>", :subject => "Your Order (##{@transaction.id})")
  end
end
