class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable,
         :database_authenticatable,
         :registerable,
         :confirmable,
         :recoverable,
         :validatable,
         :omniauthable,
         omniauth_providers: %i[facebook google_oauth2]

  has_many :profiles, dependent: :destroy
  has_many :invitations,
           class_name: 'User', as: :invited_by, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_one :trial, dependent: :destroy
  has_one :school_subscription, dependent: :destroy
  belongs_to :school, optional: true

  validates_associated :school

  validates :locale,
            presence: true,
            inclusion: { in: I18n.available_locales.collect(&:to_s) }

  before_validation :set_locale, on: :create
  before_create :build_default_profile

  scope :on_last_day_of_trial,
        -> { includes(:trial).where(trials: { expires_after: Date.current }) }

  scope :trial_ended_days_ago,
        lambda { |days_after_trial|
          includes(:trial).where(
            trials: { expires_after: days_after_trial.days.ago }
          )
        }
  scope :without_subscription,
        -> { left_joins(:subscription).where(subscriptions: { user_id: nil }) }
  scope :non_admin, -> { where(admin: false) }

  # Query methods:
  #

  # @return [Mollie::Customer, nil]
  def mollie_customer
    return unless mollie_customer_id

    @mollie_customer ||= Mollie::Customer.get(mollie_customer_id)
  end

  # @return [Mollie::Customer::Mandate, nil]
  def mollie_mandate
    return unless mollie_customer

    @mollie_mandate ||= mollie_customer.mandates.first
  end

  # Command methods:
  #
  # @return [Subscription]
  def subscribe
    subscription ? subscription.tap(&:resubscribe!) : create_subscription
  end

  # @return [Subscription]
  def unsubscribe
    subscription.tap(&:cancel!)
  end

  def self.from_omniauth(auth)
    user = User.find_by(email: auth['info']['email'])
    # In case of a new user, confirmation is bypassed as
    # email is veryfied by the third party provider already
    user ||
      User.create!(
        provider: auth['provider'],
        uid: auth['uid'],
        email: auth['info']['email'],
        password: Devise.friendly_token[0, 20],
        confirmation_token: nil,
        confirmed_at: DateTime.now
      )
  end

  def active_subscription
    return school_subscription if school_subscription&.active?

    school&.school_subscription
  end

  private

  def build_default_profile
    profiles.build
  end

  def set_locale
    self.locale ||= I18n.locale
  end
end
