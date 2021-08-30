FactoryBot.define do
  factory :visit do
    count { Random.rand(5..15) }

    association :url

    transient do
      with_ipv4 { false }
      with_ipv6 { false }
    end

    before :create do |visit, evaluator|
      visit.ipv4 = Faker::Internet.ip_v4_address if evaluator.with_ipv4
      visit.ipv6 = Faker::Internet.ip_v6_address if evaluator.with_ipv6
    end
  end
end
