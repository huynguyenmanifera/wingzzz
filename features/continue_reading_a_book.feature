@javascript
Feature: Continue reading a book
  As a parent, I would like the system to remember the last viewed page, so I do not have to spend time finding out where I left off.

  Background:
    Given the following books:
      | title                            | has_epub   | reader   | epub_with_page_images |
      | Oliver Twist                     | false      | animated | true                  |
      | Alice's Adventures in Wonderland | true       | default  | false                 |
    And the following users:
      | email                | password      |
      | john.doe@example.org | f4kep@sSw0rD! |

  @headlessUnsupported
  Scenario: Open book with whole page images with animated reader at page where we left off
    Given I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "Oliver Twist"
    And I activate the menu in the animated reader
    Then I expect to see "0 of 9"
    Then I do not expect to see "3 of 9"
    Then I turn 2 pages
    And I activate the menu in the animated reader
    Then I expect to see "3 of 9"
    When I wait 3 seconds
    And I sign out
    And I sign in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I open the book "Oliver Twist"
    And I activate the menu in the animated reader
    Then I expect to see "3 of 9"

  Scenario: Open book at page where we left off
    Given I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "Alice's Adventures in Wonderland"
    And I activate the menu
    Then I expect to see "1 of 4"
    Then I do not expect to see "3 of 4"
    And I turn 2 pages
    And I activate the menu
    Then I expect to see "3 of 4"
    When I wait 3 seconds
    And I sign out
    And I sign in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I open the book "Alice's Adventures in Wonderland"
    And I activate the menu
    Then I expect to see "3 of 4"
