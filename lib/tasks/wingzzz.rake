namespace :wingzzz do
  namespace :reminders do
    desc 'Sends all reminder emails'
    task all: %i[last_day_of_trial x_days_after_trial x_days_after_trial_for_teachers last_day_of_trial_for_teachers]

    desc 'Sends a reminder email to every user without a teacher role that is in the last day of his/her trial'
    task last_day_of_trial: :environment do
      Reminder::LastDayOfTrial.new.call
    end

    desc 'Sends a reminder email to every user with a teacher role that is in the last day of his/her trial'
    task last_day_of_trial_for_teachers: :environment do
      Reminder::LastDayOfTrialForTeachers.new.call
    end

    desc 'Sends a reminder email to every user without teacher role 3 days after the trial ended'
    task x_days_after_trial: :environment do
      days_after_trial = ENV.fetch('DAYS_AFTER_TRIAL', 3).to_i
      Reminder::TrialEnded.new(days_after_trial).call
    end

    desc 'Sends a reminder email to every user with teacher role 3 days after the trial ended'
    task x_days_after_trial_for_teachers: :environment do
      days_after_trial = ENV.fetch('DAYS_AFTER_TRIAL', 3).to_i
      Reminder::TrialEndedForTeachers.new(days_after_trial).call
    end
  end
end