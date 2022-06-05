class ParkingHistory < ApplicationRecord
  belongs_to :car

  def time
    time_now = Time.now
    if out_at.nil?
      time_dif_seconds = time_now - entry_at
      time_calculation(time_dif_seconds)
    else
      time_dif_seconds = out_at - entry_at
      time_calculation(time_dif_seconds)
    end
  end

  def left
    !out_at.nil?
  end

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
