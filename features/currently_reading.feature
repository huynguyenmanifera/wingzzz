@javascript
Feature: Currently Reading

        Background:
            Given the following books:
                  | title                            | has_epub | language | reader   | epub_with_page_images |
                  | Oliver Twist                     | false    | en       | animated | true                  |
                  | Alice's Adventures in Wonderland | true     | en       | default  | false                 |
            Given I have opened the application and signed in

        Scenario: In the beginning 'Currently Reading' shows empty tiles
             Then I expect not to see a "Currently Reading" section

        Scenario: A book once opened is added to 'Currently Reading'
              And I am reading the book "Alice's Adventures in Wonderland"
              And I activate the menu
             When I click on the exit arrow
             Then I expect to see the book "Alice's Adventures in Wonderland" in the "Currently Reading" section

        @headlessUnsupported
        Scenario: A book once opened it with the animated reader is added to 'Currently Reading'
              And I am reading the book "Oliver Twist"
              And I activate the menu in the animated reader
             When I click on the exit arrow
             Then I expect to see the book "Oliver Twist" in the "Currently Reading" section

        Scenario: A finished book is still shown in 'Currently Reading'
              And I am reading the book "Alice's Adventures in Wonderland"
              And I activate the menu
              And I turn 3 pages
              And I turn 3 pages
              And I activate the menu
             When I click "Finish"
             Then I expect to see the book "Alice's Adventures in Wonderland" in the "Currently Reading" section

        Scenario: 'Currently Reading' shows all languages
              And I am reading the book "Alice's Adventures in Wonderland"
              And I activate the menu
              And I click on the exit arrow
             When I have set my content language to 'Dutch'
             Then I expect to see the book "Alice's Adventures in Wonderland" in the "Currently Reading" section

        Scenario: 'Currently Reading' books don't show a modal preview
              And I am reading the book "Alice's Adventures in Wonderland"
              And I activate the menu
             When I click on the exit arrow
             When I click on the book "Alice's Adventures in Wonderland" in the "Currently Reading" section
             Then I should be on the page for the book "Alice's Adventures in Wonderland"
