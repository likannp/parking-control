FactoryBot.define do
  factory :parking_history do
    car { build :car }
    entry_at { 1.hours.ago }
    out_at { nil }
    paid { false }

  end
end