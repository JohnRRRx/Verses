Rails.application.routes.draw do

  root "static_pages#top"
  resources :users, only: %i[new create]
  get 'music/search', to: 'musics#search'
  resources :posts do
    collection do
      get :search
    end
  end
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

end
