@javascript
Feature: Restart reading book
  As a parent, I would like to start over from page 1, without having to navigate back several times.

  Background:
    Given the following books:
      | title                            | has_epub | reader   | epub_with_page_images |
      | Robinson Crusoe                     | false    | animated | true                  |
      | The seven lotties | true     | default  | false                 |
    And the following users:
      | email                | password      |
      | john.doe@example.org | f4kep@sSw0rD! |

 Scenario: Restart reading book
    When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "The seven lotties"
    And I activate the menu
    Then I expect to see "1 of 4"
    Then I do not expect to see "3 of 4"
    And I turn 2 pages
    And I activate the menu
    Then I expect to see "3 of 4"
    And I click on the restart icon
    Then I expect to see "1 of 4"
    Then I do not expect to see "3 of 4"

  @headlessUnsupported
  Scenario: Restart reading book in animated reader
    When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "Robinson Crusoe"
    And I activate the menu in the animated reader
    Then I expect to see "0 of 9"
    Then I do not expect to see "5 of 9"
    And I turn 3 pages
    And I activate the menu in the animated reader
    Then I expect to see "5 of 9"
    And I click on the restart icon
    Then I expect to see "0 of 9"
    Then I do not expect to see "5 of 9"

