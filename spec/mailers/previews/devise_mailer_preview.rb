class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    user = User.first
    Devise::Mailer.confirmation_instructions(user, {})
  end

  def reset_password_instructions
    user = User.first
    Devise::Mailer.reset_password_instructions(user, {})
  end

  def invitation_instructions
    user = User.first
    Devise::Mailer.invitation_instructions(user, {})
  end
end
