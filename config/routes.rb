Gifty::Application.routes.draw do
  resources :vendors do
    resources :items
  end
  match 'facebook' => 'vendors#facebook', :via => :get, :as => "facebook"
  
  match 'store/:biz_id' => 'vendors#store', :via => :get, :as => "store"
  
  resources :transactions, :only => [:index, :destroy]
  match 'checkout' => 'transactions#checkout', :via => :post, :as => "checkout"
  match 'confirmation' => 'transactions#confirmation', :via => :post, :as => "confirmation"
  
  resources :passes, :only => [:index, :destroy]
  
  resources :items do
    resources :transaction
  end
end
