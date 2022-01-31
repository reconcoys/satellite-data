require "rails_helper"

RSpec.describe "Stats", type: :request do
  describe "get stats/" do
    subject { get "/stats" }

    let(:result) { "some result" }

    it "calls the SatelliteEntryService.health method and returns the result" do
      expect(SatelliteEntryService).to receive(:recent_statistics).and_return(result)

      subject

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response.body).to eq(result)
    end
  end
end