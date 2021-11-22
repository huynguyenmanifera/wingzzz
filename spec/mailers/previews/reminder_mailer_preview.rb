# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def last_day_of_trial
    set_user
    ReminderMailer.with(user: @user).last_day_of_trial
  end

  def last_day_of_trial_for_teachers
    set_user
    ReminderMailer.with(user: @user).last_day_of_trial_for_teachers
  end

  def trial_ended
    set_user
    ReminderMailer.with(user: @user).trial_ended
  end

  def trial_ended_for_teachers
    set_user
    ReminderMailer.with(user: @user).trial_ended_for_teachers
  end

  private

  def set_user
    @user =
      FactoryBot.build(:user, locale: params[:locale]) do |user|
        user.build_trial(expires_after: Date.current)
      end
  end
end
