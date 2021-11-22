module Reminder
  class LastDayOfTrial < Base
    protected

    def description
      'Sending a reminder email to every user without a teacher role in their last day of trial'
    end

    def target_audience
      User.without_role(:teacher).non_admin.on_last_day_of_trial
        .without_subscription
    end

    def message(user)
      ReminderMailer.with(user: user).last_day_of_trial
    end
  end
end
