
namespace :service do
  desc 'Start application upstart service'
  task :start do
    on roles(:app) do
      execute "sudo service #{fetch(:application)} start"
    end
  end
  desc 'Stop application upstart service'
  task :stop do
    on roles(:app) do
      execute "sudo service #{fetch(:application)} stop"
    end
  end
end
