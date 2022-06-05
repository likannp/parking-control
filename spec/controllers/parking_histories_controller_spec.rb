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
    context "success" do
      
    end
    context "fail" do
      
    end
    
  end

  describe "GET #show" do
    context "success" do
      
    end
    context "fail" do
      
    end
    
  end
  
end