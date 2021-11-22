FactoryBot.define do
  factory :school_subscription do
    user { nil }
    contact_name { 'Bob' }
    contact_email { 'bob@example.com' }
    billing_name { 'Bob de bouwer' }
    billing_address { 'Teststraat 21' }
    billing_city { 'Amsterdam' }
    billing_brincode { 'test123' }
    end_date { Time.zone.today.end_of_year }
  end
end
