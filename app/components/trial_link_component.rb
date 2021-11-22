class TrialLinkComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
    @trial = user.trial
    @subscription = user.subscription
  end

  def render?
    !@user.admin? && (@subscription.nil? || @subscription.initialized?) &&
      !@user.has_role?(:school_subscription_member) &&
      @trial.active?
  end
end
