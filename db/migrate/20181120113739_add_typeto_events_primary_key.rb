class AddTypetoEventsPrimaryKey < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE events DROP CONSTRAINT events_pkey;
          ALTER TABLE events ADD CONSTRAINT events_pkey PRIMARY KEY (event_id, event_source, event_time, event_type);
        SQL
      end
    end
  end
end
