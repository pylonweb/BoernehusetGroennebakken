set :user, 'deployer'
set :domain, 'gronnebakken.frederikfenger.dk'
set :application, "Børnehuset Grønnebakken"
 
set :repository, "git@github.com:FengerAndFrolich/BoernehusetGroennebakken.git"  # Your clone URL
set :scm, "git"
set :branch, "deploy"
set :scm_verbose, true
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{user}/#{domain}"
set :use_sudo, false
set :rvm_type, :user

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
 
role :web, domain                         # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
 
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :deploy do
  namespace :db do
    desc <<-DESC
      Creates the database.yml configuration file in shared path.

      By default, this task uses a template unless a template \
      called database.yml.erb is found either is :template_dir \
      or /config/deploy folders. The default template matches \
      the template for config/database.yml file shipped with Rails.

      When this recipe is loaded, db:setup is automatically configured \
      to be invoked after deploy:setup. You can skip this task setting \
      the variable :skip_db_setup to true. This is especially useful \ 
      if you are using this recipe in combination with \
      capistrano-ext/multistaging to avoid multiple db:setup calls \ 
      when running deploy:setup for all stages one by one.
    DESC
    task :setup, :except => { :no_release => true } do

      template = File.read("config/database.yml")
      config = ERB.new(template)

      run "mkdir -p #{shared_path}/db" 
      run "mkdir -p #{shared_path}/config" 
      put config.result(binding), "#{shared_path}/config/database.yml"
    end

    desc <<-DESC
      [internal] Updates the symlink for database.yml file to the just deployed release.
    DESC
    task :symlink, :except => { :no_release => true } do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
    end

  end

  after "deploy:setup",           "deploy:db:setup"   unless fetch(:skip_db_setup, false)
  after "deploy:finalize_update", "deploy:db:symlink"
end
