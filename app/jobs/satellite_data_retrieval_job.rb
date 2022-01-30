class SatelliteDataRetrievalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SatelliteDataRetrievalService.add_entry_from_endpoint!
  end
end
