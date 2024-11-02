FactoryBot.define do
  factory :event do
    title { "MyString" }
    description { "MyText" }
    date { "2024-11-02 10:56:58" }
    location { "MyString" }
    organizer { nil }
    status { 1 }
  end
end
