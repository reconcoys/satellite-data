require "rails_helper"

describe SatelliteDataRetrievalService do
  describe ".add_entry_from_endpoint!" do
    subject { described_class.add_entry_from_endpoint! }

    let(:altitude) { 217.45 }
    let(:last_updated) { "2022-01-30T22:05:50" }
    let(:body) { "{\n  \"altitude\": #{altitude}, \n  \"last_updated\": \"#{last_updated}\"\n}\n" }

    before do
      stub_request(:get, "http://nestio.space/api/satellite/data")
        .to_return(:body => body, :status => 200)
    end

    it "calls the expected uri and stores the response" do
      subject
      expect(SatelliteEntry.count).to eq(1)
      last_created = SatelliteEntry.order(:created_at => :asc).last
      expect(last_created).to have_attributes(
        :altitude => altitude,
        :data_updated_at => DateTime.parse(last_updated),
        :average_altitude => altitude
      )
    end
  end
end

