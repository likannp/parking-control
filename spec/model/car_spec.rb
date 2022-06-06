require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'validation' do
    let(:car) { build :car, plate: "asd-76543"}
    
    it "Plate Invalid" do
      car.valid?
      expect(car.errors.full_messages).to include("Plate Is Invalid.")
    end

  end

  describe 'plate downcase on save' do
    let(:car) {Car.new(plate: "ATR-9876")}
    before {car.save}
    it "plate case should be always downcase" do
      expect(car.plate).to eq "atr-9876"
    end
  end
end