class ApplicationMailer < ActionMailer::Base
  add_template_helper WingzzzHelper
  around_action :with_user_locale
  default from: Wingzzz.config.action_mailer[:sender]
  layout 'mailer'

  private

  def with_user_locale
    @user = params[:user].decorate
    I18n.with_locale(@user.locale) { yield }
  end
end
