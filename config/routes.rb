Rails.application.routes.draw do
  resources :registrations, :controller => 'mori/registrations', :only => [:new, :create]
  resources :sessions, :controller => 'mori/sessions', :only => [:new, :create, :destroy]
  resources :passwords, :controller => 'mori/passwords', :only => :update do
    collection do
      get :forgot
      get :reset
      get :change
      post :send_reset
    end
  end
  get '/login' => 'mori/sessions#new', :as => 'login'
  delete '/logout' => 'mori/sessions#destroy', :as => 'logout'
  if Mori.configuration.allow_sign_up?
    get '/sign_up' => 'mori/registrations#new', :as => 'sign_up'
  end
end
