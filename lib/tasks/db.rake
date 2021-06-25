# frozen_string_literal: true

namespace :db do
  desc 'Create the events hypertable if it does not exist'
  task create_events_hypertable: :environment do
    ActiveRecord::Base.connection.execute(
      "SELECT create_hypertable('events', 'event_time', if_not_exists => TRUE);"
    )
  end

  desc 'Create the groups continuous aggregates view'
  task create_groups_continuous_aggregates: :environment do
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE VIEW group_events_daily
      WITH (timescaledb.continuous) AS
      SELECT time_bucket(INTERVAL '1 day', event_time) AS period,
            group_id,
            count(*) as count
      FROM events
      WHERE group_id IS NOT NULL
      GROUP BY group_id, period;
    SQL
  end

  desc 'Drop the groups continuous aggregates view'
  task drop_groups_continuous_aggregates: :environment do
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW IF EXISTS group_events_daily CASCADE;
    SQL
  end

  desc 'Setup the development env database'
  task :'setup:development' => %w[db:create db:schema:load db:create_events_hypertable db:create_groups_continuous_aggregates]

  desc 'Setup and seed the development env database'
  task :'setup:seed:development' => ['db:setup:development', 'db:seed']
end
