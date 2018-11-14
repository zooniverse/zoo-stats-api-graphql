class AddEventDataToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :event_data, :jsonb
  end
end
