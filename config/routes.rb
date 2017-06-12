Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    # jobs/assignments
    resources :jobs, only: [:index, :show, :update] do
      resources :assignments
    end

    # assignments
    resources :assignments, only: [:index, :show, :update]
  end

  post 'auth' => 'api/auth#authenticate'
  get 'api/user', to: 'api/users#show'
  
end
