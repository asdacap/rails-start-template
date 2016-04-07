require "whenever/capistrano"

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'rails_start_template'
set :repo_url, 'git@github.com:asdacap/rails-start-template.git'

# Default branch is :master
set :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/'+fetch(:application)

set :server_user, 'www-data'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/thin_config.yml','config/settings.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Rbenv setup
set :rbenv_type, :user
set :rbenv_ruby, "2.1.4"
set :rbenv_custom_path, "$HOME/.rbenv" # For some reason, this is needed.

# Foreman setup
set :foreman_use_sudo, :rbenv
set :foreman_options, ->{ {
  app: fetch(:application),
  user: fetch(:server_user),
  log: File.join(shared_path, 'log')
} }
set :foreman_export_path, '/etc/init'

# Permission issues
set :file_permissions_paths, fetch(:linked_dirs) + fetch(:linked_files)
set :file_permissions_users, [fetch(:server_user)]

set :config_example_suffix, '.sample'
# Nginx config
set :nginx_template, 'config/nginx.conf.erb'
set :app_server_socket, shared_path.join('tmp','sockets','thin.sock')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
