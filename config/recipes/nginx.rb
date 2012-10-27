namespace :nginx do
	desc "Setup nginx config"
	task :setup, roles: :web do
		run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
		reload
	end
	after "deploy:setup", "nginx:setup"

	task :update_config, roles: :web do
		template "nginx_unicorn.erb", "/tmp/nginx_conf"
		run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
		reload
	end
	after "deploy:finalize_update", "nginx:update_config"

	%w[start stop restart reload].each do |command|
		task command, roles: :web do
			run "#{sudo} service nginx #{command}"
		end
	end
end