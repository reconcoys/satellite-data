module SatelliteEntryService
  def self.create!(altitude, last_updated)
    altitudes = SatelliteEntry.all.map(&:altitude).push(altitude)
    average_altitude = altitudes.sum / altitudes.length

    SatelliteEntry.create!(
      :altitude => altitude,
      :data_updated_at => DateTime.parse(last_updated),
      :average_altitude => average_altitude
    )
  end
end