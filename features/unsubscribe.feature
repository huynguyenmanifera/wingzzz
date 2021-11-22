@javascript
Feature: Cancel subscription from account page

        Scenario: Cancel subscription
            Given today is "2016-08-01"
              And the following users:
                  | email                | password      |
                  | john.doe@example.org | f4kep@sSw0rD! |
              And I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
              And I navigate to 'My account'
             Then I expect to see a button to unsubscribe
             When I unsubscribe
             Then "john.doe@example.org" should receive an email
              And I expect to be on the account page
              But I expect not to see a button to unsubscribe
             When today is "2016-09-02"
              And I navigate to 'My account'
              And I expect to see a page telling me I do not have a subscription yet

