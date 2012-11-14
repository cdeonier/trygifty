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
  
  #Webservice
  constraints(:passTypeIdentifier => /[A-Za-z0-9\._\-]+/) do
    match 'service/:version/devices/:deviceLibraryIdentifier/registrations/:passTypeIdentifier/:serialNumber' => 'service#register', :via => :post, :as => "register_device"
    match 'service/:version/devices/:deviceLibraryIdentifier/registrations/:passTypeIdentifier/' => 'services#passes', :via => :get, :as => "get_device_passes"
    match 'service/:version/passes/:passTypeIdentifier/:serialNumber' => 'service#update', :via => :get, :as => "update_pass"
    match 'service/:version/devices/:deviceLibraryIdentifier/registrations/:passTypeIdentifier/:serialNumber' => 'service#unregister', :via => :delete, :as => "unregister_device"
    match 'service/:version/log' => 'service#log', :via => :post
  end
end
