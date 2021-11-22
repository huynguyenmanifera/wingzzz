class SubscriptionsController < ApplicationController
  respond_to :html
  skip_before_action :authenticate_subscription
  before_action :authenticate_teacher,
                only: %i[teacher_options new_school create_school]
  before_action :already_has_school_subscription, only: %i[new_school]
  before_action -> { @mobile_friendly = true }

  # There are only `new`/`create` actions, even if
  # the user is in the process of activating a subscription.
  # The subscription model ensures that an initialized subscription
  # can be used to continue activation.
  def new
    if current_user.subscription&.initialized?
      flash[:notice] = t('subscription_not_yet_activated')
    else
      flash.clear
    end
  end

  def teacher_options; end

  def new_school
    @school_subscription =
      SchoolSubscription.fill_billing_from_school current_user
  end

  def create_school
    school_subscription = setup_school_subscription

    if school_subscription.persisted?
      add_school_subscription_roles
      send_out_subscription_mails school_subscription
      flash[:notice] = 'successful signup'
      redirect_to new_user_invitation_url
    else
      redirect_to new_school_subscription_path
    end
  end

  def create
    subscription = current_user.subscribe
    redirect_to subscription.checkout_url
  end

  def show
    redirect_to root_url unless current_user.subscription&.pending?
  end

  private

  def setup_school_subscription
    school_subscription = SchoolSubscription.new(school_subscription_params)
    school_subscription.end_date = Time.now.utc.end_of_year
    school_subscription.save

    school_subscription
  end

  def add_school_subscription_roles
    current_user.add_role(:school_subscription_member)
    current_user.add_role(:school_subscription_owner)
  end

  def send_out_subscription_mails(school_subscription)
    UserMailer.with(user: current_user).activation_email_for_school_subscription
      .deliver_later
    UserMailer.with(
      user: current_user,
      email: Wingzzz.config.admin_email,
      school_subscription: school_subscription
    )
      .notification_email_about_school_subscription
      .deliver_later
  end

  def already_has_school_subscription
    redirect_to root_url if authenticate_school_subscription
  end

  def school_subscription_params
    params.require(:school_subscription).permit(
      %i[
        contact_email
        contact_name
        billing_name
        billing_address
        billing_city
        billing_postcode
        billing_brincode
        school_id
        user_id
      ]
    )
  end
end
