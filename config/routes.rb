Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # jobs/assignments
      resources :jobs, only: [:index, :show, :update] do
        resources :assignments
      end
      
      # assignments
      resources :assignments, only: [:index, :show, :update, :create]
      
      post 'auth' => 'auth#authenticate'
      get 'user', to: 'users#show'
      put 'user', to: 'users#update'
    end
  end
end
