class SetupTimescaleExtension < ActiveRecord::Migration[5.2]
  def change
    enable_extension "timescaledb"
  end
end
