class RemoveEventsCreatedAtFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :event_created_at, :string
  end
end
