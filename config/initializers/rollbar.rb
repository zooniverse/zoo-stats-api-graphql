Rollbar.configure do |config|
  # Without configuration, Rollbar is enabled in all environments.
  # To disable in specific environments, set config.enabled=false.

  config.access_token = Rails.application.credentials.rollbar_token
  
  # Here we'll disable in 'test':
  if Rails.env.test? || Rails.env.development?
    config.enabled = false
  end

  # Enable asynchronous reporting (uses girl_friday or Threading if girl_friday
  # is not installed)
  config.use_async = true
 
  # If you run your staging application instance in production environment then
  # you'll want to override the environment reported by `Rails.env` with an
  # environment variable like this: `ROLLBAR_ENV=staging`. This is a recommended
  # setup for Heroku. See:
  # https://devcenter.heroku.com/articles/deploying-to-a-custom-rails-environment
  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env
end
