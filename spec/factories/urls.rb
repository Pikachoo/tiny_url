FactoryBot.define do
  factory :url do
    original { Faker::Internet.url }
    token { SecureRandom.hex(3) }
  end
end
