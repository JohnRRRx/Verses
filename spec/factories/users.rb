FactoryBot.define do
  factory :user do
    sequence(:name, "test_user")
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end