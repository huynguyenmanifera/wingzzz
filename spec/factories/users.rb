FactoryBot.define do
  sequence(:mollie_customer_id) { |n| "mollie_customer_id_#{n}" }

  factory :user do
    sequence :email do |n|
      "user#{n}@example.org"
    end

    password { 'f4k3p455w0rd' }
    confirmed_at { Time.zone.now }
    locale { I18n.default_locale }

    trait :admin do
      admin { true }
    end

    trait :in_trial_period do
      trial
    end

    trait :teacher do
      after(:build) { |user, _evaluator| user.add_role(:teacher) }
    end

    trait :with_expired_trial do
      association :trial, :expired
    end

    trait :on_last_day_of_trial do
      association :trial, :on_last_day
    end

    trait :with_an_initialized_subscription do
      trial
      after(:build) do |user, _evaluator|
        user.mollie_customer_id = generate(:mollie_customer_id)
        build(
          # Set state attribute directly to bypass AASM
          :subscription,
          user: user, aasm_state: :initialized
        )
      end
    end

    trait :with_a_pending_subscription do
      trial
      after(:build) do |user, _evaluator|
        user.mollie_customer_id = generate(:mollie_customer_id)
        build(
          # Set state attribute directly to bypass AASM
          :subscription,
          user: user, aasm_state: :pending
        )
      end
    end

    trait :with_an_active_subscription do
      trial
      after(:build) do |user, _evaluator|
        user.mollie_customer_id = generate(:mollie_customer_id)
        build(
          # Set state attribute directly to bypass AASM
          :subscription,
          user: user, aasm_state: :active
        )
      end
    end

    trait :with_a_school_subscription do
      trial

      after(:build) do |user, _evaluator|
        user.add_role(:school_subscription_member)
      end

      after(:build) do |user, _evaluator|
        build(:school_subscription, user: user)
      end
    end

    trait :with_a_canceled_subscription do
      trial
      after(:build) do |user, _evaluator|
        user.mollie_customer_id = generate(:mollie_customer_id)
        build(
          # Set state attribute directly to bypass AASM
          :subscription,
          user: user, aasm_state: :canceled
        )
      end
    end
  end
end
