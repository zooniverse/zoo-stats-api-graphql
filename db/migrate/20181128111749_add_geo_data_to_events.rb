class AddGeoDataToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :country_name, :string
    add_column :events, :country_code, :string
    add_column :events, :city_name, :string
    add_column :events, :latitude, :integer
    add_column :events, :longitude, :integer
  end
end
