# frozen_string_literal: true

namespace :db do
  desc 'Create the events hypertable if it does not exist'
  task create_events_hypertable: :environment do
    ActiveRecord::Base.connection.execute(
      "SELECT create_hypertable('events', 'event_time', if_not_exists => TRUE);"
    )
  end

  desc 'Create the groups continuous aggregates view'
  task create_user_groups_continuous_aggregates: :environment do
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE VIEW group_events_daily
      WITH (timescaledb.continuous) AS
      SELECT time_bucket(INTERVAL '1 day', event_time) AS period,
            count(*) as count
      FROM events
      GROUP BY group_id, period;
    SQL
  end

  desc 'Drop the groups continuous aggregates view'
  task drop_groups_continuous_aggregates: :environment do
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW IF EXISTS group_events_daily CASCADE;
    SQL
  end

  desc 'Setup and seed the development env database'
  task :'setup:development' => %w[db:create db:schema:load db:create_events_hypertable db:create_user_groups_continuous_aggregates db:seed]
end
