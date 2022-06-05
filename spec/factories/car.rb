FactoryBot.define do
  factory :car do
    plate {"FAA-1234"}
    trait :With_invalid_place do
      plate {"FAA-123456"} 
    end
  end
end