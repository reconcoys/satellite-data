require "rails_helper"

describe SatelliteEntryService do
  describe ".create!" do
    subject { described_class.create!(input_altitude, input_updated_at) }

    context "when there are no existing entries" do
      let(:input_altitude) { 213.001 }
      let(:input_updated_at) { "2017-04-07T02:53:10.0007" }

      it "saves an entry with the correct fields" do
        subject
        expect(SatelliteEntry.count).to eq(1)
        last_created = SatelliteEntry.order(:created_at => :asc).last
        expect(last_created).to have_attributes(
          :altitude => 213.001,
          :data_updated_at => DateTime.parse(input_updated_at),
          :average_altitude => 213.001
        )
      end
    end

    context "when there are existing entries" do
      let(:input_altitude) { 12.5 }
      let(:input_updated_at) { "2017-04-07T02:53:30.0007" }

      let!(:first_entry) do
        SatelliteEntry.create!(
          :altitude => 10.5,
          :data_updated_at => DateTime.parse("2017-04-07T02:53:10.0007"),
          :average_altitude => 10.5
        )
      end
      let!(:second_entry) do
        SatelliteEntry.create!(
          :altitude => 11.5,
          :data_updated_at => DateTime.parse("2017-04-07T02:53:20.0007"),
          :average_altitude => 11.0
        )
      end

      it "saves an entry with the correct fields" do
        subject
        expect(SatelliteEntry.count).to eq(3)
        last_created = SatelliteEntry.order(:created_at => :asc).last
        expect(last_created).to have_attributes(
          :altitude => 12.5,
          :data_updated_at => DateTime.parse(input_updated_at),
          :average_altitude => 11.5
        )
      end
    end
  end

  describe ".recent_statistics" do
    subject { SatelliteEntryService.recent_statistics }

    let!(:oldest_entry) do
      SatelliteEntry.create!(
        :altitude => 10.5,
        :data_updated_at => updated_at - 4.minutes,
        :average_altitude => 10.5
      )
    end

    let!(:newest_entry) do
      SatelliteEntry.create!(
        :altitude => 11.5,
        :data_updated_at => updated_at - 1.minutes,
        :average_altitude => 11.0
      )
    end

    context "when there are recent entries" do
      let(:updated_at) { Time.zone.now }

      it "returns the expected statistics" do
        expect(subject).to include(
          :minimum => 10.5,
          :maximum => 11.5,
          :average => 11.0
        )
      end
    end

    context "when there are no recent entries" do
      let(:updated_at) { Time.zone.now - 5.minutes }

      it "returns a message indicating there is no data" do
        expect(subject).to eq("no data")
      end
    end
  end
end