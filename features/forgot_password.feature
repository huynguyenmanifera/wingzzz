Feature: Forgot password

  Scenario: Forgot password
    Given the following users:
      | email                |
      | john.doe@example.org |
    And I have opened the application
    When I click "Forgot your password?"
    And I fill in "email address" with "john.doe@example.org"
    And I click "Reset password"
    Then I expect to see a message to reset my password
    And "john.doe@example.org" should receive an email
    When I open the email
    And I follow "Change password" in the email
    And I fill in "New password" with "f4kep@sSw0rD!"
    And I fill in "Confirm your password" with "f4kep@sSw0rD!"
    And I click "Change password"
    Then I should be authenticated
