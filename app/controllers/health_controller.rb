class HealthController < ApplicationController
  def index
    render :plain => SatelliteEntryService.health
  end
end
