class ParkingHistoriesController < ApplicationController

  def create

    car = Car.find_by_plate(params[:plate].downcase)
    if car.nil?
      car = Car.new(plate: params[:plate])
      return render json: {errors: car.errors.full_messages.join(', ')}, status: 400 unless car.save
    end

    parking_history = ParkingHistory.create(car: car, entry_at: Time.now)
    render json: {reservation: parking_history.id}, status: 201
 
  end

  def out
    # A busca leva em consideração o ultimo registro realizado sem saída.
    parking_history = ParkingHistory.joins(:car).where(car: {plate: params[:plate].downcase}, out_at: nil ).last

    return render json: {errors: "Parking record not found."}, status: 404 if parking_history.nil?

    return render json: {errors: "Parking must be paid."}, status: 422 unless parking_history.paid

    parking_history.update(out_at: Time.now)
    render status: 204

  end

  def pay
    parking_history = ParkingHistory.joins(:car).where(car: {plate: params[:plate].downcase}, paid: false ).last

    return render json: {errors: "Parking record not found."}, status: 404 if parking_history.nil?

    parking_history.update(paid: true)
    render status: 204
  end

  def show
    parking_history = ParkingHistory.joins(:car).where(car: {plate: params[:plate].downcase})
    render json: parking_history.map { |value| value.as_json(only: [:id,:paid], methods: [:time,:left]) }
  end

end
