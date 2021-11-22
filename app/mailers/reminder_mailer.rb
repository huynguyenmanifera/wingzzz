class ReminderMailer < ApplicationMailer
  before_action { @trial_duration_in_days = Trials::TRIAL_DURATION_IN_DAYS }

  def last_day_of_trial
    mail(
      to: @user.email,
      subject:
        default_i18n_subject(trial_duration_in_days: @trial_duration_in_days)
    )
  end

  def last_day_of_trial_for_teachers
    mail(
      to: @user.email,
      subject:
        default_i18n_subject(trial_duration_in_days: @trial_duration_in_days)
    )
  end

  def trial_ended
    mail(
      to: @user.email,
      subject:
        default_i18n_subject(trial_duration_in_days: @trial_duration_in_days)
    )
  end

  def trial_ended_for_teachers
    mail(
      to: @user.email,
      subject:
        default_i18n_subject(trial_duration_in_days: @trial_duration_in_days)
    )
  end
end
