FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyString" }
    role { 1 }
    stripe_account_id { "MyString" }
  end
end
