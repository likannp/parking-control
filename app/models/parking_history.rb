class ParkingHistory < ApplicationRecord
  belongs_to :car

  def time
    time_calculation((out_at || Time.now) - entry_at)
  end

  def left
    !out_at.nil?
  end

  private

  def time_calculation time_dif_in_seconds
    time_dif_in_minutes = time_dif_in_seconds / 60
    if time_dif_in_minutes >= 60
      time_dif_in_hours = time_dif_in_minutes / 60
      "#{time_dif_in_hours.floor(2)} hours"
    else
      "#{time_dif_in_minutes.floor(2)} minutes"
    end
  end
end
