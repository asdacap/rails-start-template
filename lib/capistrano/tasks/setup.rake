
namespace :setup do

  desc 'Fill .env with path data'
  task :set_environment do
    on roles(:app) do
      rbenv_shims = capture("readlink -f #{fetch(:rbenv_path)}/shims")
      path = capture("echo $PATH")
      execute "echo 'PATH=#{path}:#{rbenv_shims}' >> #{release_path}/.env"
    end
  end

  desc 'Basically run db:seed'
  task :seed_user do
    on roles(:app) do
      within current_path do
        with(RAILS_ENV: fetch(:rails_env)) do
          rake 'db:seed'
        end
      end
    end
  end

  desc 'Install dependencies'
  task :install_dependencies do
    on roles(:app) do
      dependencies = "libmysqlclient-dev libreadline-dev libpq-dev libsqlite-dev build-essential acl"
      execute "sudo apt-get install -yq #{dependencies}"
    end
  end

  desc 'Install rbenv sudo plugin'
  task :install_rbenv_sudo do
    on roles fetch(:rbenv_roles) do
      next if test "[ -d #{rbenv_sudo_path} ]"
      execute :git, :clone, rbenv_sudo_repo_url, rbenv_sudo_path
    end
  end

  task :service => ['setup:set_environment','foreman:export']

  before 'deploy:starting', 'setup:install_dependencies'
  after 'rbenv:install_rbenv', 'setup:install_rbenv_sudo'
  before "deploy:updated", "deploy:set_permissions:acl"

  def rbenv_sudo_path
    "#{fetch(:rbenv_path)}/plugins/rbenv-sudo"
  end
  def rbenv_sudo_repo_url
    "git://github.com/dcarley/rbenv-sudo.git"
  end


end
