require 'rails_helper'

RSpec.describe ParkingHistory, type: :model do
  describe '#time' do
    before do
      Timecop.freeze(Time.now)
    end

    after do
      Timecop.return
    end

    let(:parking_history) { build :parking_history, out_at: out_at, entry_at: entry_at}

    context "When parking took more than 1 hour" do
      let(:out_at) {1.hours.ago}
      let(:entry_at) {3.hours.ago}
      it "return value in hours" do
        expect(parking_history.time).to eq "2.0 hours"
      end
      
    end
    context "When parking took less than 1 hour" do
      let(:out_at) {30.minutes.ago}
      let(:entry_at) {1.hours.ago}
      it "return value in minutes" do
        expect(parking_history.time).to eq "30.0 minutes"
      end
    end
    
  end
end