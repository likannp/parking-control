class ParkingHistoriesController < ApplicationController

  def create
    car = Car.find_by_plate(params[:plate])
    if car.nil?
      car = Car.new(plate: params[:plate])
      return render json: {errors: car.errors.full_messages.join(', ')}, status: 400 unless car.save
    end

    parking_history = ParkingHistory.new(car: car, entry_at: Time.now)
    if parking_history.save
      render json: {reservation: parking_history.id}
    end
  end

  def out
    binding.pry
  end

  def pay
    binding.pry
  end

  def show
    binding.pry
  end

end
