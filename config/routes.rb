# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :restaurants do
    collection do
      get :restaurant_details
      get :list_menu_items
    end

    member do
      post :import_csv
      get :new_import
    end
  end
  root 'restaurants#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
