set :application, 'DiamondMine3'
set :repo_url, 'https://github.com/miksturait/dm3.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/srv/rails/dm3'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/application.yml config/database.yml }
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rails_env, 'production'

set :rvm_type, :system
set :rvm_ruby_version, '2.0.0'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      run <<-CMD
      if [[ -f #{current_path}/tmp/pids/passenger.pid ]];
      then
        cd #{deploy_to}/current && bundle exec passenger stop --pid-file #{current_path}/tmp/pids/passenger.pid;
      fi
      CMD
      run "rm -rf /tmp/dm3.socket && cd #{deploy_to}/current && bundle exec passenger start -e #{rails_env} --socket /tmp/dm3.socket -d"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
