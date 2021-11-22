FactoryBot.define do
  factory :subscription do
    user { nil }
    sequence :token do |n|
      "token-#{n}"
    end
    sequence :mollie_subscription_id do |n|
      "mollie_subscription_id_#{n}"
    end
  end
end
