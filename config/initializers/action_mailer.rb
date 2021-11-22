ActionMailer::Base.smtp_settings =
  Wingzzz.config.action_mailer.slice(:user_name, :password, :domain).merge(
    {
      address: 'smtp.sendgrid.net',
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }
  )
