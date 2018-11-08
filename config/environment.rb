# Load the Rails application.
require_relative 'application'

# Add the utilities folder to the autoload path
Rails.application.configure do
  config.autoload_paths << "#{Rails.root}/app/graphql/utilities"
end

# Initialize the Rails application.
Rails.application.initialize!
