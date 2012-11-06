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
    @transaction = Transaction.new(params[:transaction])
    puts "!!!!!! #{@transaction.item.amount}"
    
    Stripe.api_key = "sk_test_kgL3knoDKf72dGGiBqLC8qpo"

    # get the credit card details submitted by the form
    token = params[:stripeToken]

    # create the charge on Stripe's servers - this will charge the user's card
    charge = Stripe::Charge.create(
      :amount => (@transaction.item.amount * 100).to_i,
      :currency => "usd",
      :card => token,
      :description => "#{@transaction.email} for #{@transaction.item.vendor.name}"
    )
    
    @transaction.save
  end
end
