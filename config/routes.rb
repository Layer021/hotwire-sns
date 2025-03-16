Rails.application.routes.draw do
  devise_for :users, path: '', controllers: {
    sessions: "user/auth/sessions"
  }
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "posts" => "user/posts#create", as: :user_posts

  post "posts/:id/likes" => "user/liked_posts#create", as: :user_post_likes
  delete "posts/:id/likes" => "user/liked_posts#destroy", as: :user_post_unlike

  get "users/:id" => "user/users#show", as: :user_user

  # Defines the root path route ("/")
  root to: "user/home#index"
end
