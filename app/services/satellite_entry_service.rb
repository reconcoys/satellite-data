module SatelliteEntryService
  def self.create!(input_altitude, input_updated_at)
    altitude = input_altitude.to_f
    altitudes = SatelliteEntry.all.map(&:altitude).push(altitude)

    average_altitude = altitudes.sum / altitudes.length
    data_updated_at = DateTime.parse(input_updated_at)
    SatelliteEntry.create!(
      :altitude => altitude,
      :data_updated_at => data_updated_at,
      :average_altitude => average_altitude
    )
  end
end