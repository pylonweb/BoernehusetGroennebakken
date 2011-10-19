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