# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'database_cleaner'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# load the rake tasks for use in test db schema setup
ZooStats::Application.load_tasks

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # set up factory bot
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    # setup the TimescaleDB events hypertable & continuous aggregates for the test database
    # 1. remove any existing continuous aggregates
    Rake::Task['db:drop_groups_continuous_aggregates'].invoke

    # 2. truncating all the tables in the db (clean slate)
    DatabaseCleaner.clean_with(:truncation)

    # 3. create the hypertables and check it exists
    Rake::Task['db:create_events_hypertable'].invoke
    has_hypertables_sql = "SELECT * FROM timescaledb_information.hypertable WHERE table_name = 'events';"
    if ActiveRecord::Base.connection.execute(has_hypertables_sql).to_a.empty?
      raise "TimescaleDB missing hypertable on 'events' table"
    end

    # 4. create the continuous aggregates views (groups) and check the required ones exist
    Rake::Task['db:create_groups_continuous_aggregates'].invoke
    continuous_aggregates = 'SELECT view_name, materialization_hypertable FROM timescaledb_information.continuous_aggregates;'
    known_continuous_aggregates = ActiveRecord::Base.connection.execute(continuous_aggregates)
    unless known_continuous_aggregates.find { |ca| ca['view_name'] == 'group_events_day' }
      raise "TimescaleDB missing 'group_events_day' continuous aggregates view"
    end
  end

  # setup DB Cleaner to use the faster transaction strategy
  DatabaseCleaner.strategy = :transaction

  # start the transaction strategy as examples are run
  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end