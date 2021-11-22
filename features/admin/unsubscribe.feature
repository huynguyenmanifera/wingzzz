@javascript
Feature: Manually revoke premium access from admin dashboard for user
              As an admin
              I want to remove a subscription
  So that a user cannot access the application anymore

        Scenario: Remove subscription
            Given today is "2016-08-01"
              And the following users:
                  | email                | password    | admin |
                  | john.doe@example.org | secret      | false |
                  | admin@mywingzzz.com  | more-secret | true  |
             When I have opened the application and signed in as "john.doe@example.org" "secret"
             Then I should be redirected to the home page

            Given I click on sign out
              And I have opened the application and signed in as "admin@mywingzzz.com" "more-secret"
              And I navigate to the admin panel
              And I click "Users"
              And I unsubscribe user "john.doe@example.org"
              And I click "Back to app"
              And I click on sign out

            Given I have opened the application and signed in as "john.doe@example.org" "secret"
             When I navigate to 'My account'
             Then I expect not to see a button to unsubscribe
             When I click on sign out
              And today is "2016-09-02"
              And I have opened the application and signed in as "john.doe@example.org" "secret"
             Then I expect to see a page telling me I do not have a subscription yet
