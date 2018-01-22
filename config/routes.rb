Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get '/red_yellowant/', to: 'home#red_yellowant'
  get '/redirected_url', to: 'home#redirected'
  post '/api_url/', to: 'home#api_calls'
end
