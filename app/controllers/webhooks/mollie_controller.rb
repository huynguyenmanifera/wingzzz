module Webhooks
  class MollieController < ApplicationController
    skip_before_action :http_basic_authenticate
    skip_before_action :authenticate_user!
    skip_before_action :authenticate_subscription
    skip_forgery_protection

    rescue_from ActiveRecord::RecordNotFound, with: :log_error

    ##
    # POSTed to by Mollie, to indicate status of payments.
    # This is both for initial payment of a subscription and recurring payments.
    def payment
      subscription = Subscription.find_by_mollie_payment!(params[:id]) # rubocop:disable Rails/DynamicFindBy

      if subscription.payment_canceled?
        subscription.destroy!
      else
        subscription.may_activate? && subscription.activate!
      end
    ensure
      head(:ok)
    end

    # curl -X POST -d "id=tr_cAEseaUBtg" http://localhost:5000/webhooks/mollie/subscription
    def subscription
      # See: https://docs.mollie.com/payments/recurring#how-do-webhooks-for-subscriptions-work

      # Older subscriptions still have a webhook_url configured.
      # We've chosen to keep this endpoint to avoid returning a 500 error.
      logger.tagged(self.class.name) do
        logger.info "Mollie informed us that about a new payment, but there's no need to take any action."
      end

      head(:ok)
    end

    ##
    # Users are redirected to this endpoint from Mollie.
    # This is both for succesful payments, as well as failed/canceled payments.
    # At this point, one of three things can happen:
    #
    # 1. The payment was succesful, and the subscription is activated (via the #payment webhook). Most likely case.
    # 2. The payment was canceled, in which case the subscription is already destroyed.
    # 3. The payment was succesful, but the subscription is not yet activated (payment didn't come through yet).
    #
    # When #3 occurs, the subscription is set to status 'pending' and the user will be instructed to
    # verify the payment. Hopefully, in the meantime the payment did come through and the subscription
    # is activated.
    def pay
      # subscription might not exist anymore at this point, see #1 above.
      Subscription.find_by(token: params[:token]).try do |subscription|
        subscription.may_pend? && subscription.pend!
      end

      redirect_to root_url
    end

    private

    def log_error(exception)
      logger.tagged(self.class.name) { logger.error exception }
    end
  end
end
