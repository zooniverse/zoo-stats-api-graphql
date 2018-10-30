class AddIndexToEvents < ActiveRecord::Migration[5.2]
  def change
    add_index :events, [:event_type, :user_id]
    add_index :events, [:event_type, :project_id]
  end
end
