Rails.application.routes.draw do
  get 'notifications/index'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root to: 'recipes#index'
    devise_for :users, controllers: { registrations: 'registrations' }, skip: :omniauth_callbacks
    resources :users, only: [:show]

    resources :recipes, only: [:index, :new, :create, :destroy, :show] do
      resources :likes, only: [:create, :destroy]
      resources :bookmarks, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
      collection do
        get :search
      end
      member do
        get :preview
      end
    end

    resources :notifications, only: :index do
      collection do
        post :mark_as_seen
      end
    end

    resources :relationships, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy] do
      resources :likes, only: [:create, :destroy]
    end

    # get '/search', to: 'recipes#search', as: 'search_recipe'
    # get '/preview/:id', to: 'recipes#preview', as: 'preview_recipe'
  end

  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
end
