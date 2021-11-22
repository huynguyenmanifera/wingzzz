# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def unsubscribe
    set_user
    UserMailer.with(user: @user).unsubscribe_email
  end

  def welcome
    set_user
    UserMailer.with(user: @user).welcome_email
  end

  def activation
    set_user
    UserMailer.with(user: @user, next_payment_on: 5.days.from_now.to_date)
      .activation_email
  end

  def activation_email_for_school_subscription
    set_user
    UserMailer.with(user: @user).activation_email_for_school_subscription
  end

  private

  def set_user
    @user = FactoryBot.build(:user, :in_trial_period, locale: params[:locale])
  end
end
