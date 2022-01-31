class StatisticsController < ApplicationController
  def index
    render :json => SatelliteEntryService.recent_statistics
  end
end
