class HealthController < ApplicationController
  def index
    render :json => SatelliteEntryService.health
  end
end
