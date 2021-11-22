module SectionedForm
  class SubscriptionAndBillingDetailsComponent < ViewComponent::Base
    attr_reader :user
    def initialize(user:)
      @user = user
    end

    def details?
      user.mollie_mandate &&
        user.subscription&.mollie_subscription&.next_payment_date
    end

    def school_subscription_member?
      user.has_role? :school_subscription_member
    end
  end
end
