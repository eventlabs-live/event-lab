FactoryBot.define do
  factory :event_registration do
    user { nil }
    event { nil }
    quantity { 1 }
    status { 1 }
  end
end
