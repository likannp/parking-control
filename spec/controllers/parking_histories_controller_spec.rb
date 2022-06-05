require 'rails_helper'

shared_context "successful request" do
  it "create new ParkingHistory" do
    expect {action}.to change(ParkingHistory, :count).by 1
  end
  it "response have status 200" do
    action
    expect(response.status).to be 200  
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
  
end