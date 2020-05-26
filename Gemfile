source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'graphql', '~> 1.8'
gem 'composite_primary_keys', '~> 11.1'
gem 'rollbar'
gem 'panoptes-client', '~> 0.3.8'
gem 'activerecord-import'
gem 'geocoder'
gem 'rack-cors', require: 'rack/cors'

group :production, :staging do
  gem 'newrelic_rpm'
end


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails', '~> 0.3.9'
  gem 'foreman'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.6', '>= 1.6.2'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'faker', '~> 1.8', '>= 1.8.7'
  gem 'rspec-rails', '~> 3.8'
  gem 'rspec-graphql_matchers'
  gem 'shoulda-matchers', '~> 4.3'
end
