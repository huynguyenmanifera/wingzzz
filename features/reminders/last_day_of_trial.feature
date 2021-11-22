Feature: Email 1 day before free trial ends

        Scenario: User on last day of trial without subscription
            Given the user "john.doe@example.org" on the last day of the trial without a subscription
             When Wingzzz runs a task for sending out reminders for the last day of trial
             Then "john.doe@example.org" should see the email "Your 14-day free trial will end tomorrow" with the following body:
             """
              Hello from everyone at Wingzzz!

              We hope that you have been reading plenty of stories and enjoying the Wingzzz experience.

              Your 14-day free trial will end tomorrow and we hope that you will continue your subscription.
              Just click the button below to continue.

              Enjoy the story!
             """

        Scenario: User on last day of trial with subscription
            Given the user "john.doe@example.org" on the last day of the trial with a subscription
             When Wingzzz runs a task for sending out reminders for the last day of trial
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial will end tomorrow"


        Scenario: User before last day of trial without subscription
            Given the user "john.doe@example.org" before the last day of the trial without a subscription
             When Wingzzz runs a task for sending out reminders for the last day of trial
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial will end tomorrow"

        Scenario: User before last day of trial with subscription
            Given the user "john.doe@example.org" before the last day of the trial with a subscription
             When Wingzzz runs a task for sending out reminders for the last day of trial
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial will end tomorrow"

        Scenario: User after last day of trial without subscription
            Given the user "john.doe@example.org" after the last day of the trial without a subscription
             When Wingzzz runs a task for sending out reminders for the last day of trial
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial will end tomorrow"

        Scenario: User after last day of trial with subscription
            Given the user "john.doe@example.org" after the last day of the trial with a subscription
             When Wingzzz runs a task for sending out reminders for the last day of trial
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial will end tomorrow"

        Scenario: Admin
            Given the admin user "john.doe@example.org" on the last day of the trial without a subscription
             When Wingzzz runs a task for sending out reminders for the last day of trial
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial will end tomorrow"
