class AddEventDataToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :data, :jsonb
  end
end
