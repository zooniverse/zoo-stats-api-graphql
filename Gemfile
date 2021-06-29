# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'activerecord-import'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'composite_primary_keys', '~> 11.1'
gem 'geocoder'
gem 'graphql', '~> 1.8'
gem 'panoptes-client', '~> 0.3.8'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.2'
gem 'rollbar'

group :production, :staging do
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'foreman'
  gem 'pry-rails'
  gem 'rubocop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'database_cleaner', '~> 1.6', '>= 1.6.2'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'faker', '~> 1.8', '>= 1.8.7'
  gem 'rspec-graphql_matchers'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'
end
