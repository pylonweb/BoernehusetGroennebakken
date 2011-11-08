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
  
  #Create database.yml on the server using local database.yml settings
  namespace :db do
    desc <<-DESC
          Create database.yml on the remote server based on local database.yml file
        DESC
    task :setup, :except => { :no_release => true } do
      template = File.read("config/database.yml")
      config = ERB.new(template)
      run "mkdir -p #{shared_path}/db" 
      run "mkdir -p #{shared_path}/config" 
      put config.result(binding), "#{shared_path}/config/database.yml"
    end

    #Symlink shared/database.yml
    desc <<-DESC
          [internal] Updates the symlink for database.yml file to the just deployed release.
        DESC
    task :symlink, :except => { :no_release => true } do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
    end
  end
  
  #Create newrelic.yml on the server using local newrelic.yml settings
  namespace :newrelic do
    desc <<-DESC
          Create newrelic.yml on the remote server based on local newrelic.yml file
        DESC
    if File.exist? "config/newrelic.yml"
      task :setup, :except => { :no_release => true } do
        template = File.read("config/newrelic.yml")
        config = ERB.new(template)
        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/newrelic.yml"
      end
  
      #Symlink shared/newrelic.yml
      desc <<-DESC
            [internal] Updates the symlink for newrelic.yml file to the just deployed release.
          DESC
      task :symlink, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml" 
      end
    else
      "error: newrelic.yml not found!"
    end
  end
  
  desc <<-DESC
        [internal] Run bundle command on remote server
      DESC
  task :bundle, :roles => :app do
    run "cd #{latest_release} && bundle"
  end
  
  desc <<-DESC
        Merge master branch into deploy branch and push it
        
        Specify another branch with BRANCH={branch}
    DESC
  task :merge do
    if ENV.has_key?('BRANCH')
      if `git branch` =~ /ENV['BRANCH']/i
        branch = ENV['BRANCH']
      else
        raise ArgumentError, "unknown branch: #{ENV['BRANCH']}"
      end
    else
      branch = "master"
    end
    
    system("git checkout #{branch}")
    system("git checkout -b temp")
    system("git merge --strategy=ours deploy")
    system("git checkout deploy")
    system("git merge temp")
    system("git branch -d temp")
    system("git push origin deploy --force")
    system("git checkout #{branch}")
  end

  #after "deploy:bundle",          "deploy:migrate"
  after "deploy:update_code",     "deploy:bundle",      "deploy:newrelic:setup"
  after "deploy:setup",           "deploy:db:setup"   unless fetch(:skip_db_setup, false)
  after "deploy:finalize_update", "deploy:db:symlink",  "deploy:newrelic:symlink"
end
