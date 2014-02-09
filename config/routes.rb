Rails.application.routes.draw do
  resources :users, :controller => 'mori/users', :only => [:new, :create]
  if Mori.configuration.allow_sign_up?
    get '/sign_up' => 'mori/users#new', as: 'sign_up'
  end
end
