Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Root of the app
  root 'call#index'

  #calls
  get 'calls' => 'call#index', :as => :all_calls
  get 'call/:id' => 'call#show', :as => :call_details

  #receive callback from twillio on call status changes
  post 'status' => 'call#save_call_details'

  # webhook for your Twilio number
  match 'ivr/welcome' => 'call#ivr_welcome', via: [:get, :post], as: 'welcome'

  # callback for user entry
  match 'ivr/selection' => 'call#menu_selection', via: [:get, :post], as: 'menu'
end
