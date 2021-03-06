Dm3::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "home#index"
  resources :coworkers

  namespace :api, defaults: {format: 'json'} do
    resources :work_entries, only: :index
    resources :work_units, only: :index
    resources :coworkers, only: :index
  end

  namespace :dm2 do
    get "dashboard/workload_import"
    get "dashboard/statistics"
    get "time/summary"
    get "api/work_units"
    get "finance/create_invoice"
    get "finance/healthcheck"
  end
end
