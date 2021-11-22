FactoryBot.define do
  factory :trial do
    expires_after { 14.days.from_now }
    user

    trait :expired do
      expires_after { 14.days.ago }
    end

    trait :on_last_day do
      expires_after { Date.current }
    end
  end
end
