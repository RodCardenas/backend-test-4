Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Root of the app
  root 'calls#index'

  # webhook for your Twilio number
  match 'ivr/welcome' => 'calls#ivr_welcome', via: [:get, :post], as: 'welcome'

  # callback for user entry
  match 'ivr/selection' => 'calls#menu_selection', via: [:get, :post], as: 'menu'
end
