# Load the Rails application.
require_relative 'application'

# Add the utilities folder to the autoload path
Rails.application.configure do
  config.autoload_paths << "#{Rails.root}/app/graphql/utilities"
  config.autoload_paths << "#{Rails.root}/app/graphql/mutations"
  config.autoload_paths << "#{Rails.root}/app/graphql/mutations/transformers"
end

# Initialize the Rails application.
Rails.application.initialize!
