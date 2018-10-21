Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :topics do
    resources :comments, only: [:create, :destroy, :edit, :update]
    
    collection do
      get :feeds
    end

    member do
      post :collect
      post :uncollect
    end
  end

  post '/topics/:topic_id/comments/:id', to: 'comments#update_comment', as: 'update_comment'
  
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :comments
      get :collects
      get :drafts
      get :friends
    end
  end

  resources :categories, only: :show

  resources :friendships, only: [:create, :edit, :update]

  
  root "topics#index"

  namespace :admin do
    resources :categories
    resources :users
    root "categories#index"
  end
end
