class Car < ApplicationRecord
  has_many :parking_histories
  validate :invalid_plate_format
  before_save :downcase_plate!

  private
  
  def invalid_plate_format
    validate = plate.match(/^[a-zA-Z]{3}-[0-9]{4}$/)
    errors.add(:plate, :invalid, message: "Is Invalid.") if validate.nil?
  end

  def downcase_plate!
    self.plate = self.plate.downcase
  end
end
