module Reminder
  class LastDayOfTrialForTeachers < Base
    protected

    def description
      'Sending a reminder email to every user with a teacher role in their last day of trial'
    end

    def target_audience
      # rolify cannot combine with_role + without_role here, so exclude the school subscriptions by id
      User.with_role(:teacher).where.not(id: school_subscription_member_ids)
        .on_last_day_of_trial
        .non_admin
        .without_subscription
    end

    def message(user)
      ReminderMailer.with(user: user).last_day_of_trial_for_teachers
    end

    private

    def school_subscription_member_ids
      User.with_role(:school_subscription_member).pluck(:id)
    end
  end
end
