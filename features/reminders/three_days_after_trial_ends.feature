Feature: Email 3 days after free trial ends

        Scenario: User in trial
            Given the user "john.doe@example.org" in trial
             When Wingzzz runs a task for sending out reminders 3 days after the trial ends
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial has ended"

        Scenario: User before 3rd day after trial
            Given the user "john.doe@example.org" 1 day after trial
             When Wingzzz runs a task for sending out reminders 3 days after the trial ends
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial has ended"

        Scenario: User on 3rd day after trial without subscription
            Given the user "john.doe@example.org" 3 days after trial without a subscription
             When Wingzzz runs a task for sending out reminders 3 days after the trial ends
             Then "john.doe@example.org" should see the email "Your 14-day free trial has ended" with the following body:
             """
              Hello from everyone at Wingzzz!

              We hope that you have been reading plenty of stories and enjoying the Wingzzz experience.

              We noticed your 14-day free trial has come to an end and hope that you will continue your subscription.
              Just click the button below to continue.
             """

        Scenario: User on 3rd day after trial with subscription
            Given the user "john.doe@example.org" 3 days after trial with a subscription
             When Wingzzz runs a task for sending out reminders 3 days after the trial ends
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial has ended"

        Scenario: User after 3rd day after trial
            Given the user "john.doe@example.org" 4 days after trial with a subscription
             When Wingzzz runs a task for sending out reminders 3 days after the trial ends
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial has ended"

        Scenario: Admin
            Given the admin user "john.doe@example.org" on the last day of the trial without a subscription
             When Wingzzz runs a task for sending out reminders 3 days after the trial ends
             Then "john.doe@example.org" should receive no email with subject "Your 14-day free trial has ended"


