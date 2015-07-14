set :application, 'Dashingproject'
set :repo_url, 'https://github.com/Qwinix/dashingproject.git'
set :scm, :git

set :format, :pretty

set :default_env, { :path => "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.2-p95'
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}
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

desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end
