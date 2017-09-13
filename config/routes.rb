Rails.application.routes.draw do

  apipie
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # jobs/assignments
      resources :jobs, only: [:index, :show, :update] do
        resources :assignments
        resources :comments, controller: 'job_comments'
      end
      
      # assignments
      resources :assignments, only: [:index, :show, :update, :create] do
        post 'attachment' => 'attachments#create'
        get 'attachment/:id' => 'attachments#show'
      end
      
      get 'auth' => 'auth#authenticate'
      
      get 'user', to: 'users#show'
      put 'user', to: 'users#update'
      get 'logout' => 'users#logout'
    end
  end

  namespace :admin do

    resources :users
    resources :tenants
    resources :clients
    resources :jobs, only: [:index, :update, :new, :create, :edit, :destroy] do
      resources :assignments, only: [:index, :new, :create, :update, :edit]
    end
    
    get 'login' => 'session#index'
    get 'logout' => 'session#destroy'
    post 'login' => 'session#create'
    get 'dashboard' => 'dashboard#index'

    put 'batch_update_invoice_numbers' => 'batch_update#update_invoice_numbers'
    
  end
  
end
