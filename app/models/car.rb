class Car < ApplicationRecord
  has_many :parking_histories
  validate :invalid_plate_format

  private
  
  def invalid_plate_format
    validate = plate.match(/^[a-zA-Z]{3}-[0-9]{4}$/)
    errors.add(:plate, :invalid, message: "Invalid Car Plate") if validate.nil?
  end
end
