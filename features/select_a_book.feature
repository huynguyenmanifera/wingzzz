@javascript
Feature: Select a book
              As a parent, I would like to select a book, so I can read it.

        Background:
            Given the following books:
                  | title                            | language |
                  | Oliver Twist                     | en       |
                  | Alice's Adventures in Wonderland | en       |
                  | The Adventures of Tom Sawyer     | en       |
                  | Zaza speelt doktertje            | nl       |

        Scenario: System lists books alphabetically
             When I have opened the application and signed in
              And I have set my content language to 'English'
             Then I should see books in order
      """
              Alice's Adventures in Wonderland
      Oliver Twist
      The Adventures of Tom Sawyer
      """

        Scenario: System only lists books in profile's content language
             When I have opened the application and signed in
              And I have set my content language to 'English'
             Then I should see the following books:
                  | title                            |
                  | Oliver Twist                     |
                  | Alice's Adventures in Wonderland |
                  | The Adventures of Tom Sawyer     |
              But I should not see the following books:
                  | title                            |
                  | Zaza speelt doktertje            |

        Scenario: Click on a book to read it
             When I have opened the application and signed in
              And I have set my content language to 'English'
              And I click on the book "Alice's Adventures in Wonderland"
              And I click the "Read book" button
             Then I should be on the page for the book "Alice's Adventures in Wonderland"

        Scenario: Set content language
            Given I have opened the application and signed in
             When I have set my content language to "Dutch"
             Then I expect my content language is saved as "Dutch"
