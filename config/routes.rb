Gifty::Application.routes.draw do
  resources :vendors do
    resources :items
  end
  match 'facebook' => 'vendors#facebook', :via => :post, :as => "facebook"
  
  match 'store/:biz_id' => 'vendors#store', :via => :get, :as => "store"
  
  resources :transactions, :only => [:index, :destroy]
  match 'checkout' => 'transactions#checkout', :via => :post, :as => "checkout"
  match 'confirmation' => 'transactions#confirmation', :via => :post, :as => "confirmation"
  
  resources :passes, :only => [:index, :destroy]
  match 'redeem/:serial_number' => 'passes#redeem', :via => :get, :as => "redeem"
  match 'redeem_confirmation/:serial_number' => 'passes#redeem_confirmation', :via => :post, :as =>"redeem_confirmation"
  match 'charged/:serial_number' => 'passes#charged', :via => :post, :as => "charged"
  
  resources :items do
    resources :transaction
  end
end
