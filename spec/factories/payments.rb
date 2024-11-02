FactoryBot.define do
  factory :payment do
    registration { nil }
    amount { "9.99" }
    payment_method { "MyString" }
    status { 1 }
    stripe_payment_intent_id { "MyString" }
  end
end
