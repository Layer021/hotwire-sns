Rails.application.routes.draw do
  devise_for :users, path: '', controllers: {
    sessions: "user/auth/sessions"
  }
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope module: :user do
    get "home" => "home#index", as: :user_home
    get "home/timeline" => "home#timeline", as: :user_home_timeline

    post "posts" => "posts#create", as: :user_posts
    delete "posts/:id" => "posts#destroy", as: :user_post_destroy

    post "posts/:id/likes" => "liked_posts#create", as: :user_post_likes
    delete "posts/:id/likes" => "liked_posts#destroy", as: :user_post_unlike

    get "users" => "users#index", as: :user_users

    get "users/:id" => "users#show", as: :user_user
    get "users/:id/timeline" => "users#timeline", as: :user_user_timeline

    post "users/:id/follows" => "following_users#create", as: :user_user_follows
    delete "users/:id/follows" => "following_users#destroy", as: :user_user_unfollow
  end

  # Defines the root path route ("/")
  root to: redirect("/home")
end
