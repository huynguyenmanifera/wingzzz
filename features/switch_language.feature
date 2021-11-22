Feature: Switch language
  As a parent, I would like to switch language, so I can read books in a different language.

  Scenario: Switch language
    Given I have opened the application and signed in
    When I navigate to 'My account'
    And I expect to see "Language"
    And I do not expect to see "Taal"

    When I click on 'Edit settings'
    And I change user language to "Dutch"
    And I click on 'Save'
    Then I expect to see "Taal"
    And I do not expect to see "Language"

  @javascript
  Scenario: Switch language after render (i.o. redirect)
    Given I have opened the application
    When I click "Forgot your password?"
    And I click "Reset password"
    And I switch language to "Nederlands"
    Then I expect to see "Wachtwoord vergeten?"
