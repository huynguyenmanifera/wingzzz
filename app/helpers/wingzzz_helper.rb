module WingzzzHelper
  def localized_subscription_amount
    number_to_currency(
      Subscription::AMOUNT_VALUE,
      unit: Subscription::AMOUNT_CURRENCY,
      precision: 2,
      strip_insignificant_zeros: true
    )
  end

  def localized_class_subscription_amount
    number_to_currency(
      Subscription::AMOUNT_VALUE_FOR_CLASS_SUBSCRIPTION,
      unit: Subscription::AMOUNT_CURRENCY,
      precision: 2,
      strip_insignificant_zeros: true
    )
  end

  def localized_school_subscription_amount
    number_to_currency(
      Subscription::AMOUNT_VALUE_FOR_SCHOOL_SUBSCRIPTION,
      unit: Subscription::AMOUNT_CURRENCY,
      precision: 2,
      strip_insignificant_zeros: true
    )
  end
end
