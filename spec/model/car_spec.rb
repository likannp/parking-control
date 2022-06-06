require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'validation' do
    let(:car) { build :car, plate: "asd-76543"}
    
    it "Plate Invalid" do
      car.valid?
      expect(car.errors.full_messages).to include("Plate Is Invalid.")
    end

  end
end