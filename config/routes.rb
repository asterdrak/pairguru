Rails.application.routes.draw do
  devise_for :users

  root "home#welcome"
  get "home/top_users"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
      post :comment
      delete "comment/:comment_id", to: "movies#destroy_comment", as: :comment_delete
    end
    collection do
      get :export
    end
  end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :movies, only: [:index, :show]
    end
    namespace :v2 do
      resources :movies, only: :index
    end
  end
end
