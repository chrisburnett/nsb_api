Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # jobs/assignments
      resources :jobs, only: [:index, :show, :update] do
        resources :assignments
        resources :comments, controller: 'job_comments'
      end
      
      # assignments
      resources :assignments, only: [:index, :show, :update, :create]
      
      get 'auth' => 'auth#authenticate'
      get 'user', to: 'users#show'
      put 'user', to: 'users#update'
    end
  end

  namespace :admin do

    resources :users
    resources :tenants, only: [:index]
    resources :clients, only: [:index]
    resources :jobs, only: [:index, :new, :create] do
      resources :assignments, only: [:index, :new, :create]
    end
    
    get 'login' => 'session#index'
    get 'logout' => 'session#destroy'
    post 'login' => 'session#create'
    get 'dashboard' => 'dashboard#index'

    #root to: 'dashboard#index'
    
  end
  
end
