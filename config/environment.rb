# Load the rails application
require File.expand_path('../application', __FILE__)
config.load_paths << "#{RAILS_ROOT}/config"

# Initialize the rails application
BoernehusetGroennebakken::Application.initialize!
