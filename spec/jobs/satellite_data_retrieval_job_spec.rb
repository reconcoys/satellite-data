require 'rails_helper'

RSpec.describe SatelliteDataRetrievalJob, type: :job do
  context "perform" do
    it "calls the SatelliteDataRetrievalService" do
      expect(SatelliteDataRetrievalService).to receive(:add_entry_from_endpoint!).once
      SatelliteDataRetrievalJob.perform_now
    end
  end
end
