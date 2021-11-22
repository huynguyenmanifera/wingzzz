# See: https://docs.mollie.com/payments/recurring
#
# This model serves as a state machine that tracks
# the status of the subscription.
# This makes it eas(y|ier) to do things as checking
# if a transition is allowed, creating Mollie objects
# at the right moment, etc.
class Subscription < ApplicationRecord
  include SubscriptionLifecycle

  RESOURCE_NOT_FOUND_ERROR_MSG =
    'Unable to retrieve a Mollie payment: %s'.freeze

  belongs_to :user

  delegate :mollie_customer_id, :mollie_customer_id=, to: :user

  class << self
    def find_by_mollie_payment!(payment_id)
      assert(payment_id)
      payment = get_mollie_payment(payment_id)
      get_decorated_subscription(payment)
    end

    private

    def assert(payment_id)
      return if payment_id.present?

      raise ActiveRecord::RecordNotFound,
            RESOURCE_NOT_FOUND_ERROR_MSG % 'Payment ID is not provided'
    end

    def get_mollie_payment(payment_id)
      Mollie::Payment.get(payment_id)
    rescue Mollie::ResourceNotFoundError => e
      raise ActiveRecord::RecordNotFound,
            RESOURCE_NOT_FOUND_ERROR_MSG % e.message
    end

    def get_decorated_subscription(mollie_payment)
      user = User.find(mollie_payment.metadata.wz_user_id)
      user.subscription.tap { |s| s.mollie_payment = mollie_payment }
    end
  end

  # Query methods:
  #
  def mollie_subscription
    @mollie_subscription ||=
      Mollie::Customer::Subscription.get(
        mollie_subscription_id,
        customer_id: user.mollie_customer_id
      )
  end

  def in_grace_period?
    grace_period_ends_on.nil? || grace_period_ends_on >= Date.current
  end

  def grace_period_ended?
    !in_grace_period?
  end

  def payment_canceled?
    !mollie_payment.paid? && !mollie_payment.open?
  end

  private

  def set_token
    loop do
      self.token = SecureRandom.urlsafe_base64
      break unless token_exists?
    end
  end

  def token_exists?
    self.class.where(token: token).exists?
  end

  def set_grace_period
    self.grace_period_ends_on = mollie_subscription.next_payment_date
  end
end
