source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'cancan'
gem 'figaro'
gem 'haml-rails'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'pg'
gem 'rolify'
gem 'simple_form', '>= 3.0.0.rc'

gem 'ancestry'
gem 'time_diff'
gem 'youtrack_api', git: 'https://github.com/eisnerd/youtrack-rest-ruby-library.git'
gem "active_model_serializers"
gem "select2-rails"

gem 'activeadmin', github: 'gregbell/active_admin'
gem "activeadmin-sortable-tree", github: "nebirhos/activeadmin-sortable-tree"

group :production do
  gem 'passenger'
  gem 'mysql'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'mysql'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'codeclimate-test-reporter', require: nil
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end
