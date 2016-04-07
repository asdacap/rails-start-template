require 'erb'

namespace :config do

  desc 'Delete the local config files for each stage'
  task :delete do
    run_locally do
      fetch(:config_files).each do |config|
        local_path = CapistranoUploadConfig::Helpers.get_local_config_name(config, fetch(:stage).to_s)
        if File.exists?(local_path)
          info "Deleted #{local_path}"
          File.delete(local_path)
        else
          info "#{local_path} not found. Ignoring..."
        end
      end
    end
  end

  task :prepare_config_push => ['deploy:check:directories','deploy:check:linked_dirs','deploy:check:make_linked_dirs']

  before 'config:push', 'config:prepare_config_push'

end
