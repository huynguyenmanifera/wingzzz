Given(
  'the user {string} on the last day of the trial without a subscription'
) { |email| create(:user, :on_last_day_of_trial, email: email) }

Given(
  'the user {string} on the last day of the trial with a subscription'
) do |email|
  create(
    :user,
    :with_an_active_subscription,
    :on_last_day_of_trial,
    email: email
  )
end

Given(
  'the user {string} before the last day of the trial without a subscription'
) { |email| create(:user, :in_trial_period, email: email) }

Given('the user {string} in trial') do |email|
  step "the user '#{
         email
       }' before the last day of the trial without a subscription"
end

Given(
  'the user {string} before the last day of the trial with a subscription'
) do |email|
  create(:user, :in_trial_period, :with_an_active_subscription, email: email)
end

Given(
  'the user {string} after the last day of the trial without a subscription'
) { |email| create(:user, :with_expired_trial, email: email) }

Given(
  'the user {string} after the last day of the trial with a subscription'
) do |email|
  create(:user, :with_expired_trial, :with_an_active_subscription, email: email)
end

Given(
  'the admin user {string} on the last day of the trial without a subscription'
) { |email| create(:user, :admin, :on_last_day_of_trial, email: email) }

Given('the user {string} {int} day after trial') do |email, days_after_trial|
  create(
    :user,
    email: email, trial: build(:trial, expires_after: days_after_trial.days.ago)
  )
end

Given(
  'the user {string} {int} days after trial without a subscription'
) do |email, days_after_trial|
  create(
    :user,
    email: email, trial: build(:trial, expires_after: days_after_trial.days.ago)
  )
end

Given(
  'the user {string} {int} days after trial with a subscription'
) do |email, days_after_trial|
  create(
    :user,
    :with_an_active_subscription,
    email: email, trial: build(:trial, expires_after: days_after_trial.days.ago)
  )
end
