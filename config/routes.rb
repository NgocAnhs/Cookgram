Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root to: 'recipes#index'
    devise_for :users, skip: :omniauth_callbacks
    resources :users, only: [:show]
    resources :recipes, only: [:index, :new, :create, :show] do
      resources :likes, only: [:create, :destroy]
      resources :bookmarks, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :comments, only: [:create, :destroy] do
      resources :likes, only: [:create, :destroy]
    end
    get '/search', to: 'recipes#search', as: 'search_recipe'
  end
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
end
