module SatelliteDataRetrievalService
  SATELLITE_URL = "http://nestio.space/api/satellite/data"

  def self.add_entry_from_endpoint!
    uri = URI(SATELLITE_URL)
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)

    SatelliteEntryService.create!(result["altitude"], result["last_updated"])
  end
end