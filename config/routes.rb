Rails.application.routes.draw do
  scope :parking do
    post "/", to: "parking_histories#create"
    put "/:plate/out", to: "parking_histories#out"
    put "/:plate/pay", to: "parking_histories#pay"
    get "/:plate", to: "parking_histories#show"
  end
end
