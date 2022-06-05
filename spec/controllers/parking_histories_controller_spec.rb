require 'rails_helper'

shared_context "successful request" do
  it "create new ParkingHistory" do
    expect {action}.to change(ParkingHistory, :count).by 1
  end
  it "response have status 200" do
    action
    expect(response.status).to be 201  
  end
  it "response have body" do
    action
    expect(JSON.parse(response.body)).to eq({"reservation" => ParkingHistory.last.id})
  end
end

RSpec.describe ParkingHistoriesController, type: :controller do
  describe "POST #create" do
    let(:action) {post :create, params: {plate: plate}}
    
    context "success" do
      let(:plate) {"AbC-4543"}

      context "when there is no car with the plate" do
        it "Create new Car" do
          expect {action}.to change(Car, :count).by 1
        end

        it_behaves_like "successful request"
      end

      context "when there is a car with the plate" do
        before {create(:car, plate: plate)}

        it "Does not create a car" do
          expect {action}.not_to change(Car, :count)
        end

        it_behaves_like "successful request"
      end
    end

    context "fail" do
      let(:plate) {"AbC-1234567"}

      context "invalid car plate" do
        it "Does not create a car" do
          expect {action}.not_to change(Car, :count)
        end
        it "response have error message" do
          action
          expect(JSON.parse(response.body)).to eq("errors" => "Plate Is Invalid.") 
        end
        it "response have status 400" do
          action
          expect(response.status).to be 400
        end
      end

    end

  end

  describe "PUT #out" do
    let(:parking_history) {create(:parking_history, paid: true)}
    let(:action) {put :out, params: {plate: parking_history.car.plate}}
  
    context "success" do
      it "went from nil to a value" do
        action
        expect(parking_history.reload.out_at).not_to be_nil
      end
      it "response have status 204" do
        action
        expect(response.status).to be 204
      end 
    end
    context "fail" do
      let(:parking_history) {create(:parking_history, paid: false)}

      context "Attempt to leave without paying" do
        it "response have status 422" do
          action
          expect(response.status).to be 422
        end
        it "response have body payment error" do
          action
          expect(JSON.parse(response.body)).to eq({"errors" => "Parking must be paid."})
        end
      end

      context "Registration not performed" do
        let(:action) {put :out, params: {plate: "AAA-7653"}}
        it "response have status 404" do
          action
          expect(response.status).to be 404
        end
        it "response have body" do
          action
          expect(JSON.parse(response.body)).to eq({"errors" => "Parking record not found."})
        end
      end
    end
    
  end

  describe "PUT #pay" do
    let(:parking_history) {create(:parking_history)}
    let(:action) {put :pay, params: {plate: parking_history.car.plate}}

    context "success" do
      it "went from nil to a value" do
        action
        expect(parking_history.reload.paid).not_to be_nil
      end
      it "response have status 204" do
        action
        expect(response.status).to be 204
      end
      
      context "Payment not made" do
        it "response have status 204" do
          action
          expect(response.status).to be 204
        end
      end

    end

    context "fail" do
      context "Registration not performed" do
        let(:action) {put :pay, params: {plate: "AAA-7653"}}
        it "response have status 404" do
          action
          expect(response.status).to be 404
        end
        it "response have body" do
          action
          expect(JSON.parse(response.body)).to eq({"errors" => "Parking record not found."})
        end
      end
      
    end
    
  end

  describe "GET #show" do
    let(:parking_history) {create(:parking_history)}
    let(:parking_history_paid_true) {create(:parking_history, car: parking_history.car, paid: true, out_at: 30.minutes.ago)}
    let(:action) {get :show, params: {plate: parking_history.car.plate}}

    context "success" do
      before {parking_history_paid_true}
      it "response have body" do
        action
        expect(JSON.parse(response.body)).to match([{
          "id" => parking_history.id,
          "paid" => parking_history.paid,
          "time" => "1.0 hours",
          "left" => false
        },
        {
          "id" => parking_history_paid_true.id,
          "paid" => parking_history_paid_true.paid,
          "time" => "29.99 minutes",
          "left" => true
        }
        ])
      end
      
    end
  end
  
end