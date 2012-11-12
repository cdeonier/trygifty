class StripeChargeJob < Struct.new(:token, :transaction)
  def perform
    puts "------> Doing Stripe Charge"
    Stripe.api_key = "sk_test_kgL3knoDKf72dGGiBqLC8qpo"

    #create the charge on Stripe's servers - this will charge the user's card
    charge = Stripe::Charge.create(
      :amount => (transaction.item.amount * 100).to_i,
      :currency => "usd",
      :card => token,
      :description => "#{transaction.email} for #{transaction.item.vendor.name}"
    )
  end
end