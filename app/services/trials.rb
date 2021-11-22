class Trials
  private_class_method :new

  TRIAL_DURATION_IN_DAYS = Wingzzz.config.trial[:duration_in_days]

  def self.start(user)
    expires_after = TRIAL_DURATION_IN_DAYS.days.from_now(Date.yesterday) # expires_after is inclusive

    user.create_trial(expires_after: expires_after)
    if user.has_role? :teacher
      UserMailer.with(user: user).welcome_email_for_teachers.deliver_later
    else
      UserMailer.with(user: user).welcome_email.deliver_later
    end
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordNotSaved
    user.reload if user.persisted?
  end
end
