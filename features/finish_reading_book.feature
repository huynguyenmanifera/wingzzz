@javascript
Feature: Finish reading book
  As a parent, I would like to finish reading a book, so when I open the book the next time,
  it automatically starts from page 1

  Background:
    Given the following books:
      | title                            | has_epub | reader   | epub_with_page_images |
      | Oliver Twist                     | false    | animated | true                  |
      | Alice's Adventures in Wonderland | true     | default  | false                 |
    And the following users:
      | email                | password      |
      | john.doe@example.org | f4kep@sSw0rD! |

  Scenario: Finish reading a book
    Given I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    When I am reading the book "Alice's Adventures in Wonderland"
    And I activate the menu
    Then I expect to see "1 of 4"
    When I turn 3 pages
    And I turn 3 pages
    And I activate the menu
    Then I expect to see "4 of 4"
    And I expect to see "Finish"
    When I click "Finish"
    And I am reading the book "Alice's Adventures in Wonderland"
    And I activate the menu
    Then I expect to see "1 of 4"

  @headlessUnsupported
  Scenario: Finish reading a book in animated reader
    Given I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    When I am reading the book "Oliver Twist"
    And I activate the menu in the animated reader
    Then I expect to see "0 of 9"
    Then I use the right arrow key 5 times
    And I wait 3 seconds
    And I activate the menu in the animated reader
    Then I expect to see "9 of 9"
    And I expect to see "Finish"
    When I click "Finish"
    And I am reading the book "Oliver Twist"
    And I activate the menu in the animated reader
    And I expect to see "0 of 9"
