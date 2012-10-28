namespace :newrelic do
	desc "Setup newrelic.yml"
	task :setup, roles: :app do
		template "newrelic.yml.erb", "#{shared_path}/config/newrelic.yml"
	end
	after "deploy:setup", "newrelic:setup"

	task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"
	end
	after "deploy:finalize_update", "newrelic:symlink"
end