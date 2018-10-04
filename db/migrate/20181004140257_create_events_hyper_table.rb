class CreateEventsHyperTable < ActiveRecord::Migration[5.2]
  def change
    create_table :events, primary_key: %i[event_id event_source event_time] do |t|
      t.bigint    :event_id
      t.string    :event_type
      t.string    :event_source
      t.timestamp :event_time, null: false
      t.timestamp :event_created_at
      t.bigint    :project_id
      t.bigint    :workflow_id
      t.bigint    :user_id
      t.string    :subject_ids, default: [], array: true
      t.string    :subject_urls, default: [], array: true
      t.string    :lang
      t.string    :user_agent
      t.string    :user_name
      t.string    :project_name
      t.bigint    :board_id
      t.bigint    :discussion_id
      t.bigint    :focus_id
      t.string    :focus_type
      t.string    :section
      t.text      :body
      t.string    :url
      t.string    :focus
      t.string    :board
      t.string    :tags, default: [], array: true
      t.bigint    :user_zooniverse_id
      t.bigint    :zooniverse_id
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          SELECT create_hypertable('events', 'event_time');
        SQL
      end
    end
  end
end
