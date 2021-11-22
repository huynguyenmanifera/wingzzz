module Reminder
  class TrialEndedForTeachers < Base
    def initialize(days_after_trial = 3)
      @days_after_trial = days_after_trial
    end

    protected

    def description
      'Sending a reminder email to every teacher user three days after end of trial'
    end

    def target_audience
      # rolify cannot combine with_role + without_role here, so exclude the school subscriptions by id
      User.with_role(:teacher).where.not(id: school_subscription_member_ids)
        .non_admin
        .trial_ended_days_ago(@days_after_trial)
        .without_subscription
    end

    def message(user)
      ReminderMailer.with(user: user).trial_ended_for_teachers
    end

    private

    def school_subscription_member_ids
      User.with_role(:school_subscription_member).pluck(:id)
    end
  end
end
