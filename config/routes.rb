Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do

    # jobs/assignments
    resources :jobs do
      resources :assignments
      resources :comments
    end

    # assignments accessible from users
    resources :users do
      resources :assignments
    end

    # assignments
    resources :assignments

    # tenants
    resources :tenants
  end

  post 'auth' => 'auth#authenticate'
  
end
