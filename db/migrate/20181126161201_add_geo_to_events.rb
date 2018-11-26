class AddGeoToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :geo, :string
  end
end
