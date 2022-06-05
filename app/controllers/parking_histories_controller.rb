class ParkingHistoriesController < ApplicationController

  def create

    car = Car.find_by_plate(params[:plate])
    if car.nil?
      car = Car.new(plate: params[:plate])
      return render json: {errors: car.errors.full_messages.join(', ')}, status: 400 unless car.save
    end

    parking_history = ParkingHistory.create(car: car, entry_at: Time.now)
    render json: {reservation: parking_history.id}
 
  end

  def out
    #erro em caso de carro não cadastrado
    #erro em caso de pagamento
    # A busca leva em consideração o ultimo registro realizado sem saída.
    parking_history = ParkingHistory.joins(:car).where(car: {plate: params[:plate].downcase}, out_at: nil ).last

    return render json: {errors: "Parking record not found."}, status: 404 if parking_history.nil?

    return render json: {errors: "Parking must be paid."}, status: 422 unless parking_history.paid

    parking_history.update(out_at: Time.now)
    render status: 204

  end

  def pay
    #erro em caso de carro não cadastrado
    #sucesso em caso de carro já pago, porém adicionar teste no cenario onde ele não pode dá erro.Tem que retorna o mesmo do contexto de sucesso.
    binding.pry
  end

  def show
    #erro em caso de carro não cadastrado
    binding.pry
  end

end
