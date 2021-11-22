module Reminder
  class TrialEnded < Base
    def initialize(days_after_trial = 3)
      @days_after_trial = days_after_trial
    end

    protected

    def description
      "Sending a reminder email to every user #{
        @days_after_trial
      } days after the trial ended"
    end

    def target_audience
      User.without_role(:teacher).non_admin.trial_ended_days_ago(
        @days_after_trial
      )
        .without_subscription
    end

    def message(user)
      ReminderMailer.with(user: user).trial_ended
    end
  end
end
