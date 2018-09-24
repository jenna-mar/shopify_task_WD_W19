Rails.application.routes.draw do
  root 'application#home'

  get '/search', to: 'requests#search'
  post '/addstar', to: 'requests#addstar', as: :add_star
  post '/removestar', to: 'requests#removestar', as: :remove_star
end
