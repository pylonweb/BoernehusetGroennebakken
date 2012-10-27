require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/check"
load "config/recipes/newrelic"

server "server1.pylonweb.dk", :web, :app, :db, primary: true

set :application, "gronnebakken"
set :primary_domain, 'gronnebakken.dk'
set :secondary_domains, ['server1.pylonweb.dk']
set :redirect_domains, ['www.gronnebakken.dk']
set :user, 'deployer'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:pylonweb/BoernehusetGroennebakken.git"
set :branch, "deploy"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases