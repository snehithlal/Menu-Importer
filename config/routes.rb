Rails.application.routes.draw do
  devise_for :users

  resources :restaurants do
    collection do 
      get :restaurant_details
    end
    
    member do
      post :import_csv
      get :new_import
    end
  end
  resources :imports
  root "restaurants#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
