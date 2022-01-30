class CreateSatelliteEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :satellite_entries do |t|
      t.float :altitude
      t.float :average_altitude
      t.datetime :data_updated_at

      t.timestamps
    end
  end
end
