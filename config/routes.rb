Rails.application.routes.draw do
  resources :registrations, :controller => 'mori/registrations', :only => [:new, :create] do
    collection do
      get :confirmation
    end
  end
  resources :sessions, :controller => 'mori/sessions', :only => [:create]
  resources :passwords, :controller => 'mori/passwords', :only => [] do
    collection do
      get :forgot
      get :reset
      get :change
      post :send_reset
      post :update
      post :reset_password
    end
  end
  resources :invites, :controller => 'mori/invites', :only => [:show, :new] do
    collection do
      put :accept
      post :send_user
    end
  end
  get '/login' => 'mori/sessions#new', :as => 'login'
  delete '/logout' => 'mori/sessions#destroy', :as => 'logout'
  if Mori.configuration.allow_sign_up?
    get '/sign_up' => 'mori/registrations#new', :as => 'sign_up'
  end
end
