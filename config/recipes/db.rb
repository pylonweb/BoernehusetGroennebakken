namespace :db do
	desc "Push the local database to the server"
	task :push, roles: :app do

		username = fetch(:user)
		password = tmp_pass(username)

		options = {username: username, password: password}

		load_taps
		run_cmd(:push, options)
	end
	
	task :pull, roles: :app do

		username = fetch(:user)
		password = tmp_pass(username)

		options = {username: username, password: password}

		load_taps
		run_cmd(:pull, options)
	end

	def load_taps
		require 'rubygems'
		begin
  		gem 'taps', '>= 0.2.8', '< 0.4.0'
  		require 'taps/cli'
		rescue LoadError
  		raise "Install the Taps gem to use db commands. On most systems this will be:\nsudo gem install taps"
		end
		require 'digest/sha1'
	end

	def remote_database_url
		db_config = capture %Q{cat #{shared_path}/config/database.yml}
		db_config = YAML::load(db_config)[rails_env]
		return "postgres://#{db_config['username']}:#{db_config['password']}@#{db_config['host']}/#{db_config['database']}"
	end

	def local_database_url
		db_config = YAML.load(File.read(File.expand_path('../../database.yml', __FILE__)))['development']
		case db_config["adapter"]
		when "sqlite3"
			return "sqlite://#{File.expand_path('../../../', __FILE__)}/#{db_config['database']}"
		when "pg"
			return "postgres://#{db_config['username']}:#{db_config['password']}@#{db_config['host']}/#{db_config['database']}?encoding=utf8"
		end
	end

	def remote_url(opts = {})
		return "http://#{opts[:username]}:#{opts[:password]}@#{opts[:host]}:#{taps_port}"
	end

	def taps_client(local_database_url, remote_url, method) 
		opts = {}
		opts[:default_chunksize] = 1000
		opts[:database_url] = local_database_url
		opts[:remote_url] = remote_url
    Taps::Config.verify_database_url(opts[:database_url])
    puts "SÅ prøver vi lige at køre taps....."
    Taps::Cli.new([]).clientxfer(method, opts)
	end

	def run_cmd(method, opts = {})
		puts opts
		data_so_far = ""
		run %Q{taps server #{remote_database_url}?encoding=utf8 #{opts[:username]} #{opts[:password]} --port=#{taps_port}} do |channel, stream, data|
			data_so_far << data
			if data_so_far.include? "WEBrick::HTTPServer#start"
				host = channel[:host]
				options = opts.merge!(host: host)
				remote_url = remote_url(options)
				# command = "taps #{method.to_s} #{local_database_url} #{remote_url}"
				# system(command)
				taps_client(local_database_url, remote_url, method)

				data_so_far = ""
        channel.close
        channel[:status] = 0
			end
		end
	end

	def check_dependencies

	end

	def tmp_pass(user)
		Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{user}--")
	end
end