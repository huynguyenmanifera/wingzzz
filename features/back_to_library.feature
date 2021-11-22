@javascript
Feature: Back to library
  As a parent, I would like to navigate back to the library page while having a book opened, so I can select a different book.

        Background:
            Given the following books:
                  | title                            | has_epub  | language  | reader    | epub_with_page_images |
                  | Oliver Twist                     | false     | en        | animated  | true                  |
                  | Alice's Adventures in Wonderland | true      | en        | default   | false                  |
              And the following users:
                  | email                | password      |
                  | john.doe@example.org | f4kep@sSw0rD! |

        Scenario: Navigate back to library
             When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
              And I am reading the book "Alice's Adventures in Wonderland"
              And I activate the menu
              And I click on the exit arrow
             Then I should see the book "Oliver Twist"

        @headlessUnsupported
        Scenario: Navigate back to library from animated reader
             When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
              And I am reading the book "Oliver Twist"
              And I activate the menu in the animated reader
              And I click on the exit arrow
             Then I should see the book "Alice's Adventures in Wonderland"
