Rails.application.routes.draw do
  get 'notifications/index'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
    root to: 'home#index'
    post '/rate' => 'rater#create', :as => 'rate'
    devise_for :users, controllers: { registrations: 'registrations', passwords: 'passwords' }, skip: :omniauth_callbacks
    resources :users, only: [:show]
    resources :home, only: [:index] do 
      collection do
        get :search
      end
      member do
        get :preview
      end
    end
    resources :recipes, except: :index do
      resources :likes, only: [:create, :destroy]
      resources :bookmarks, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end

    resources :notifications, only: :index do
      collection do
        post :mark_as_read
      end
    end

    resources :relationships, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy] do
      resources :likes, only: [:create, :destroy]
    end
  end

  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
end
