class ChangeLatLonToBeDecimalsInEvents < ActiveRecord::Migration[5.2]
  def change
    change_column :events, :latitude, :decimal
    change_column :events, :longitude, :decimal
  end
end
