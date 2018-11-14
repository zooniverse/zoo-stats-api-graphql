class AddSessionTimeToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :session_time, :datetime
  end
end
