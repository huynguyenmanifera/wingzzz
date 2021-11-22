class UserMailer < ApplicationMailer
  def unsubscribe_email
    mail(to: @user.email, subject: default_i18n_subject)
  end

  def welcome_email
    @trial_duration_in_days = Trials::TRIAL_DURATION_IN_DAYS

    mail(to: @user.email, subject: default_i18n_subject)
  end

  def welcome_email_for_teachers
    @trial_duration_in_days = Trials::TRIAL_DURATION_IN_DAYS

    mail(to: @user.email, subject: default_i18n_subject)
  end

  def activation_email
    @next_payment_on = params[:next_payment_on]

    mail(to: @user.email, subject: default_i18n_subject)
  end

  def activation_email_for_class_subscription
    @next_payment_on = params[:next_payment_on]

    mail(to: @user.email, subject: default_i18n_subject)
  end

  def activation_email_for_school_subscription
    mail(to: @user.email, subject: default_i18n_subject)
  end

  def notification_email_about_school_subscription
    @school_subscription = params[:school_subscription]
    mail(to: params[:email], subject: default_i18n_subject)
  end
end
