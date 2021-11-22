Feature: Sign out
  As a parent, I would like to sign out, so I can protect my account.

  Scenario: Redirect to sign in form when not authenticated
    When I have opened the application and signed in
    And I click on sign out
    Then I should be on the sign in page

  Scenario: Log out will end session
    When I have opened the application and signed in
    And I click on sign out
    Then I should not be authenticated
