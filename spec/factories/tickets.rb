FactoryBot.define do
  factory :ticket do
    ticket_type { nil }
    registration { nil }
    qr_code { "MyString" }
  end
end
