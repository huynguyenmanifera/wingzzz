@javascript
Feature: Book progress change
  As a publishers, I would like track users' book progress events, so I know how much revenue to receive from Wingzzz.

  Background:
    Given the following books:
      | title                            | has_epub |
      | Alice's Adventures in Wonderland | true     |
    And the following users:
      | email                | password      |
      | john.doe@example.org | f4kep@sSw0rD! |

  Scenario: Book progress change events are logged
    When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "Alice's Adventures in Wonderland"
    And I turn 2 pages
    And I wait 2 seconds
    Then I expect event "book_progress_change" to be logged
