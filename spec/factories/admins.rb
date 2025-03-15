FactoryBot.define do
  factory :admin do
    name { |n| "admin#{n}" }
    email { |n| "admin#{n}@example.com" }
  end
end
