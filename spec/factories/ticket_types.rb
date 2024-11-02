FactoryBot.define do
  factory :ticket_type do
    name { "MyString" }
    description { "MyString" }
    price { "9.99" }
    capacity { 1 }
    event { nil }
  end
end
