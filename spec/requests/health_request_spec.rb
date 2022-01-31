require "rails_helper"

RSpec.describe "Health", type: :request do
  describe "get health/" do
    subject { get "/health" }

    let(:result) { "some result" }

    it "calls the SatelliteEntryService.health method and returns the result" do
      expect(SatelliteEntryService).to receive(:health).and_return(result)

      subject

      expect(response.content_type).to eq("text/plain; charset=utf-8")
      expect(response.body).to eq(result)
    end
  end
end