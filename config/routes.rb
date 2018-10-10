Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :topics do
    resources :comments, only: [:create, :destroy]
    
    collection do
      get :feeds
    end

    member do
      post :favorite
      post :unfavorite
    end
  end
  
  resources :users, only: [:index, :show, :edit, :update]

  resources :categories, only: :show
  
  root "topics#index"

  namespace :admin do
    resources :categories
    resources :users
    root "categories#index"
  end
end
