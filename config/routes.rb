Dm3::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "home#index"
  resources :coworkers

  namespace :dm2 do
    post "api/workload_import"
  end
end
