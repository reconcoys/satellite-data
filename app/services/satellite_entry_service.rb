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

  def self.recent_statistics
    recent_altitudes = SatelliteEntry
      .where(:data_updated_at => 5.minutes.ago..)
      .pluck(:altitude)

    return "no data" if recent_altitudes.none?

    {
      :minimum => recent_altitudes.min,
      :maximum => recent_altitudes.max,
      :average => recent_altitudes.sum / recent_altitudes.length
    }
  end
end