require 'pass_creation_job'
require 'stripe_charge_job'

class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end
  
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    
    redirect_to transactions_path
  end
  
  def checkout
    @item = Item.find(params[:item_id])
    @transaction = @item.transactions.build
  end

  def confirmation
    token = params[:stripeToken]
    
    @transaction = Transaction.new(params[:transaction])
    
    item = @transaction.item
    vendor = item.vendor
    
    pass = Pass.new
    pass.amount = item.amount
    pass.item_id = item.id
    pass.vendor_id = vendor.id
    pass.save

    @transaction.pass_id = pass.id
    @transaction.save
    
    #remove when using workers
    Passbook.createPass(pass)
    
    #Delayed::Job.enqueue PassCreationJob.new(pass)
    #Delayed::Job.enqueue StripeChargeJob.new(token, @transaction)
    #OrderMailer.delay.order_confirmation(pass)
    #OrderMailer.delay.order_notification(pass)
  end
end
