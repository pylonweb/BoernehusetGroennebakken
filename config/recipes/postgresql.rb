set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { application }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
set_default(:postgresql_database) { "#{application}_production" }

namespace :postgresql do
  def db_exists
		result = capture(%Q{#{sudo} -u postgres psql template1 -c "SELECT count(datname) FROM pg_database WHERE datname='#{postgresql_database}'" | grep -c 1}).to_i
		# puts "result: #{result}"
		if result > 0 then true else false end
  end

  # puts "db_exists: #{db_exists}"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    unless db_exists
      run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
      run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
    end
  end
  after "deploy:setup", "postgresql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
  	unless db_exists
    	run "mkdir -p #{shared_path}/config"
			template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
   	end
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"
end