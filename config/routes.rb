# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :posts, only: %i[index new create show edit update destroy] do
    collection do
      get :search
      get :likes
    end
  end
  resources :likes, only: %i[create destroy]
  get 'music/search', to: 'musics#search'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
end
