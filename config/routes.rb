Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do 
    namespace :v1 do
      resources :plans do
        resources :transactions
      end
      resources :categories
      resources :users, only: [:show, :create, :update, :destroy]
    end
  end
end
