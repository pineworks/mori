Rails.application.routes.draw do

  root :to => 'application#index'
  get 'test_login' => 'application#test_login'
end
