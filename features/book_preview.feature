@javascript
Feature: Book preview

        Background:
            Given the following books:
                  | title        | summary                                                       | slug      | language |
                  | Alice's Adventures in Wonderland | The story of a young orphan boy in early Victorian England... | epub_test | en       |

        Scenario: Show book preview
            Given I have opened the application and signed in
             When I click on the book "Alice's Adventures in Wonderland"
             Then I should see a preview for the book "Alice's Adventures in Wonderland"
