Rails.application.routes.draw do
  # devise_for :stores
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'
  # devise_for :drivers
  # get "/" => redirect("/admin")
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
  # ActiveAdmin.routes(self)
  # devise_for :customers
  namespace :api do
    draw :v1
  end
  # scope "auth" do
  #   post "google", to: "api/v1/auth/google#login"
  #   post "facebook", to: "api/v1/auth/facebook#login"
  #   post "apple", to: "api/v1/auth/apple#login"
  # end
end
