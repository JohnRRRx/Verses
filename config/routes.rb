Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  get "oauths/oauth"
  get "oauths/callback"
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :posts, only: %i[index new create show edit update destroy] do
    collection do
      get :search
      get :likes
      get :mine
    end
  end
  resources :likes, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
  get 'music/search', to: 'musics#search'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  post "oauth/callback" => "oauths#callback"
  delete 'logout', to: 'user_sessions#destroy'
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
end
