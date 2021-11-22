class ApplicationController < ActionController::Base
  before_action :http_basic_authenticate
  before_action :authenticate_user!
  before_action :authenticate_subscription
  before_action :configure_tracking,
                if: -> { request.get? }, unless: -> { request.xhr? }
  before_action :process_analytics_event,
                if: -> { params.key? :analytics_event }
  before_action :set_locale

  protected

  # This logic needs a refactor

  # rubocop:disable Metrics/AbcSize
  def authenticate_subscription_redirect_url
    if current_user.nil? || current_user.admin? ||
         current_user.trial&.active? ||
         current_user.has_role?(:school_subscription_member)
      return
    end

    subscription = current_user.subscription

    return new_subscription_url_for(current_user) if subscription.nil?
    return if subscription.canceled? && subscription.in_grace_period?

    url_for_subscription current_user, subscription
  end
  # rubocop:enable Metrics/AbcSize

  def url_for_subscription(user, subscription)
    case subscription.aasm.current_state
    when :initialized, :canceled
      new_subscription_url_for(user)
    when :pending
      subscription_url
    end
  end

  def new_subscription_url_for(user)
    if user&.has_role?(:teacher)
      subscriptions_teacher_options_url
    else
      new_subscription_url
    end
  end

  def http_basic_authenticate
    return unless needs_authentication?

    authenticate_or_request_with_http_basic do |name, password|
      admin = Wingzzz.config.admin
      name == admin[:name] && password == admin[:password]
    end
  end

  def current_user
    super&.decorate
  end

  def process_analytics_event
    AhoyTracker.process_analytics_event(ahoy, params[:analytics_event])
  rescue AhoyTracker::EventProcessingError => e
    Rails.logger.warn e
  end

  def current_user_tracking_data
    {
      'language' => I18n.locale.to_sym,
      'userId' => current_user&.id,
      'subscriptionStatus' =>
        current_user&.subscription&.aasm_state || 'unknown'
    }
  end

  private

  def configure_tracking
    tracker { |t| t.google_tag_manager :push, current_user_tracking_data }
  end

  def needs_authentication?
    Wingzzz.config.admin[:name].present?
  end

  def authenticate_subscription
    return unless (url = authenticate_subscription_redirect_url)

    redirect_to url
  end

  def authenticate_teacher
    return if current_user.has_role? :teacher

    redirect_to new_subscription_path
  end

  def authenticate_school_subscription
    current_user.has_any_role?(
      :school_subscription_member,
      :school_subscription_owner
    )
  end

  def set_locale
    I18n.locale =
      params[:locale] || current_user&.locale ||
        http_accept_language.compatible_language_from(I18n.available_locales) ||
        I18n.default_locale
  end
end
