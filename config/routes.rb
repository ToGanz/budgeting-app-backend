Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do 
    resources :plans, only: [:index, :show]
  end
end
