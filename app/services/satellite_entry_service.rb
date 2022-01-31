module SatelliteEntryService
  RECENT_STATISTICS_WINDOW_MINUTES = 5
  HEALTH_WINDOW_SECONDS = 60
  AVERAGE_ALTITUDE_THRESHOLD = 160

  module HEALTH_RESPONSE
    FAILURE = "WARNING: RAPID ORBITAL DECAY IMMINENT"
    RESUMED = "Sustained Low Earth Orbit Resumed"
    OK = "Altitude is A-OK"
    NOT_ENOUGH_DATA = "Not Enough Data"
  end

  module STATISTICS_RESPONSE
    NO_DATA = "No Data"
  end

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
      .where("data_updated_at >= ?", RECENT_STATISTICS_WINDOW_MINUTES.minutes.ago)
      .pluck(:altitude)

    return STATISTICS_RESPONSE::NO_DATA if recent_altitudes.none?

    {
      :minimum => recent_altitudes.min,
      :maximum => recent_altitudes.max,
      :average => recent_altitudes.sum / recent_altitudes.length
    }
  end

  def self.health
    first_entry_of_window_timestamp = SatelliteEntry
      .where("data_updated_at < ?", HEALTH_WINDOW_SECONDS.seconds.ago)
      .order(:data_updated_at => :desc)
      .pluck(:data_updated_at)
      .first

    return HEALTH_RESPONSE::NOT_ENOUGH_DATA unless first_entry_of_window_timestamp

    entries_in_window = SatelliteEntry
      .where("data_updated_at >= ?", first_entry_of_window_timestamp)

    last_entry_below_threshold_in_window_timestamp = entries_in_window
      .where("average_altitude < ?", AVERAGE_ALTITUDE_THRESHOLD)
      .order(:data_updated_at => :desc)
      .pluck(:data_updated_at)
      .first

    if entries_in_window.all? { |entry| entry.average_altitude < AVERAGE_ALTITUDE_THRESHOLD }
      HEALTH_RESPONSE::FAILURE
    elsif last_entry_below_threshold_in_window_timestamp&.after?(HEALTH_WINDOW_SECONDS.seconds.ago)
      HEALTH_RESPONSE::RESUMED
    else
      HEALTH_RESPONSE::OK
    end
  end
end