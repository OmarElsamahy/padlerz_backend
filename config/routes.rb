Rails.application.routes.draw do
  devise_for :admin_users
  # mount Rswag::Api::Engine => '/api-docs'
  get "/" => redirect("/admin")
  devise_for :users
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
  ActiveAdmin.routes(self)
  namespace :api do
    draw :v1
  end
end

