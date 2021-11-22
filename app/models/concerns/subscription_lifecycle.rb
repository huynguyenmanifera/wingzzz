require 'active_support/concern'

module SubscriptionLifecycle # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern

  MOLLIE_SUBSCRIPTION = Wingzzz.config.subscription
  AMOUNT_VALUE = MOLLIE_SUBSCRIPTION.dig(:amount, :value)
  AMOUNT_VALUE_FOR_CLASS_SUBSCRIPTION =
    MOLLIE_SUBSCRIPTION.dig(:amount_for_class_subscription, :value)
  AMOUNT_VALUE_FOR_SCHOOL_SUBSCRIPTION =
    MOLLIE_SUBSCRIPTION.dig(:amount_for_school_subscription, :value)
  AMOUNT_CURRENCY = MOLLIE_SUBSCRIPTION.dig(:amount, :currency)
  INTERVAL = MOLLIE_SUBSCRIPTION[:interval]

  included do
    include AASM
    include Rails.application.routes.url_helpers

    attr_accessor :mollie_customer, :mollie_payment

    aasm do
      state :initialized,
            initial: true,
            before_enter: %i[set_token setup_first_payment],
            after_enter: :save_user
      state :pending
      state :active,
            before_enter: :create_mollie_subscription,
            after_enter: :send_activation_mail
      state :canceled, before_enter: :cancel_mollie_subscription

      event :pend do
        transitions from: :initialized, to: :pending
      end

      event :activate do
        transitions from: %i[initialized pending],
                    to: :active,
                    guard: :pending_or_valid_mandate?
      end

      event :cancel do
        transitions from: :active, to: :canceled
      end

      event :resubscribe do
        transitions from: %i[initialized canceled], to: :initialized
      end
    end
  end

  private

  # This method implements the first step
  # when dealing with recurring payments using Mollie.
  # See: https://docs.mollie.com/payments/recurring#setting-up-the-first-payment
  def setup_first_payment
    return unless user

    find_or_create_mollie_customer
    create_mollie_payment
    set_checkout_url
  end

  def find_or_create_mollie_customer
    self.mollie_customer =
      if mollie_customer_id
        Mollie::Customer.get(mollie_customer_id)
      else
        Mollie::Customer.create(
          email: user.email, metadata: { wz_user_id: user.id }
        )
      end
    self.mollie_customer_id = mollie_customer.id
  end

  def create_mollie_payment
    self.mollie_payment =
      Mollie::Payment.create(
        amount: { value: amount_by_user, currency: AMOUNT_CURRENCY },
        customerId: mollie_customer_id,
        sequenceType: 'first',
        description: 'Wingzzz first payment',
        redirect_url: webhooks_mollie_payment_redirect_url(token),
        webhook_url: webhooks_mollie_payment_url(webhook_options),
        metadata: { wz_user_id: user.id }
      )
  end

  def set_checkout_url
    self.checkout_url = mollie_payment._links['checkout']['href']
  end

  def save_user
    user&.save
  end

  def pending_or_valid_mandate?
    mollie_mandate.valid? || mollie_mandate.pending?
  end

  def mollie_mandate
    @mollie_mandate ||=
      Mollie::Customer::Mandate.get(
        mollie_payment.mandate_id,
        customer_id: mollie_customer_id
      )
  end

  # This method implements the last step
  # when dealing with recurring payments using Mollie.
  # See: https://docs.mollie.com/payments/recurring#charging-periodically-with-subscriptions
  def create_mollie_subscription
    subscription =
      Mollie::Customer::Subscription.create(
        customer_id: mollie_customer_id,
        amount: { value: amount_by_user, currency: AMOUNT_CURRENCY },
        interval: interval_in_words,
        startDate: starts_on,
        description: 'Wingzzz monthly payment'
      )
    self.mollie_subscription_id = subscription.id
  end

  def cancel_mollie_subscription
    set_grace_period
    delete_mollie_subscription
    revoke_mollie_mandate
  end

  def delete_mollie_subscription
    Mollie::Customer::Subscription.delete(
      mollie_subscription_id,
      customer_id: mollie_customer_id
    )
  end

  def revoke_mollie_mandate
    user.mollie_mandate.delete(customer_id: mollie_customer_id)
  end

  def interval_in_words
    [interval_value, interval_unit.pluralize(interval_value)].join(' ')
  end

  def starts_on
    @starts_on ||=
      (user.trial.days_left.days + subscription_interval).from_now.to_date
  end

  def interval_value
    INTERVAL[:value]
  end

  def interval_unit
    INTERVAL[:unit]
  end

  def subscription_interval
    interval_value.send(interval_unit)
  end

  def webhook_options
    return unless Rails.env.development?

    { host: Wingzzz.config.exit_node_host, protocol: 'https', port: false }
  end

  def send_activation_mail
    if user.has_role? :teacher
      UserMailer.with(user: user, next_payment_on: starts_on)
        .activation_email_for_class_subscription
        .deliver_later
    else
      UserMailer.with(user: user, next_payment_on: starts_on).activation_email
        .deliver_later
    end
  end

  def amount_by_user
    return AMOUNT_VALUE_FOR_CLASS_SUBSCRIPTION if user.has_role? :teacher

    AMOUNT_VALUE
  end
end
