When(
  'Wingzzz runs a task for sending out reminders for the last day of trial'
) do
  require 'rake'
  Wingzzz::Application.load_tasks
  Rake::Task['wingzzz:reminders:last_day_of_trial'].execute
end

When(
  'Wingzzz runs a task for sending out reminders 3 days after the trial ends'
) do
  require 'rake'
  Wingzzz::Application.load_tasks
  Rake::Task['wingzzz:reminders:x_days_after_trial'].execute
end
