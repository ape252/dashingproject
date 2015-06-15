set :application, 'Dashingproject'
set :repo_url, 'https://github.com/Qwinix/dashingproject.git'
set :scm, :git
set :puma_threads,    [4, 16]
set :puma_workers,    1
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :format, :pretty

set :default_env, { :path => "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.0.0-p247'
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :bundle_gemfile, proc { release_path.join('Gemfile') }
set :bundle_dir, proc  { shared_path.join('bundle') }
set :bundle_flags, '--deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, proc  { shared_path.join('bin') }
set :bundle_roles, :all
set :bundle_bins, %w(gem rake rails)
set :ssh_options, {
   config: false
}

# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5


before 'deploy:updated', 'deploy:copy_database_yml'

namespace :deploy do

  desc "Copy database.yml.example"
  task :copy_database_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      execute "cp -f #{release_path}/config/database.example.yml #{shared_path}/config/database.yml"
      execute "rm -f #{release_path}/config/database.yml"
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "rm -f #{release_path}/config/database.example.yml"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), :in => :sequence, :wait => 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  task :redis_server do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute redis-server
        end
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), :in => :groups, :limit => 3, :wait => 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

namespace :assets do
    task :precompile do
      on roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "assets:precompile RAILS_ENV=production"
          end
        end
      end
    end
  end
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end
