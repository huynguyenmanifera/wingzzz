class UserDecorator < ApplicationDecorator
  delegate_all
  decorates_association :subscription

  def localized_trail_period_expired_from
    l(trial.expires_after.tomorrow, format: :long)
  end
end
