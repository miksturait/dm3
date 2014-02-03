Dm3::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "home#index"
  resources :coworkers

  namespace :dm2 do
    get "api/workload_import"
    get "api/statistics"
    get "api/summary"
  end
end
