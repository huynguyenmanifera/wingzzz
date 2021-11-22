class SubscriptionDecorator < ApplicationDecorator
  delegate_all

  def formatted_next_payment_date
    I18n.l(mollie_subscription.next_payment_date, format: :long)
  end
end
