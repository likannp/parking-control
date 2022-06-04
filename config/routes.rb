Rails.application.routes.draw do
  namespace :parking do
    post "/", to: "parking#create"
    put "/:id/out", to: "parking#out"
    put "/:plate/pay", to: "parking#pay"
    get "/:plate", to: "parking#show"
  end
end
