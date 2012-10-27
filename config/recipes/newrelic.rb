namespace :newrelic do
	desc "Setup newrelic.yml"
	task :setup, roles: :app do
		template "newrelic.yml.erb", "#{shared_path}/config/newrelic.yml"
	end
	after "deploy:setup", "newrelic:setup"
end