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

  def self.health
    first_entry_older_than_a_minute_timestamp = SatelliteEntry
      .where("data_updated_at < ?", 60.seconds.ago)
      .order(:data_updated_at => :desc)
      .pluck(:data_updated_at)
      .first

    return "Not enough data" unless first_entry_older_than_a_minute_timestamp

    entries_in_window = SatelliteEntry
      .where("data_updated_at >= ?", first_entry_older_than_a_minute_timestamp)

    last_entry_below_threshold_in_window_timestamp = entries_in_window
      .where("average_altitude < ?", 160)
      .order(:data_updated_at => :desc)
      .pluck(:data_updated_at)
      .first

    if entries_in_window.all? { |entry| entry.average_altitude < 160 }
      "WARNING: RAPID ORBITAL DECAY IMMINENT"
    elsif last_entry_below_threshold_in_window_timestamp&.after?(1.minute.ago)
      "Sustained Low Earth Orbit Resumed"
    else
      "Altitude is A-OK"
    end
  end
end