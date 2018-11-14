class AddTypeSpecificDataToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :type_specific_data, :string
  end
end
