# require "net/http"

module SatelliteDataRetrievalService
  def self.add_entry_from_endpoint!
    uri = URI("http://nestio.space/api/satellite/data")
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)

    SatelliteEntryService.create!(result["altitude"], result["last_updated"])
  end
end