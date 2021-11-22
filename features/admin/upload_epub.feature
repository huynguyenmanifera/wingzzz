@javascript
Feature: Upload EPUB
              As a content manager, I want to be able to upload the EPUB for a book

        Background:
            Given the following books:
                  | title        | has_epub |
                  | Oliver Twist | false    |

        Scenario: Upload EPUB
            Given I have opened the application and signed in as admin
             When I have opened the book "Oliver Twist"
             Then I do not expect to see any pages
             When I navigate to the admin panel
             Then I expect to see "Oliver Twist"
             When I click "Oliver Twist"
              And I click "Edit EPUB"
              And I attach EPUB file "spec/fixtures/epub/epub_test.zip"
              And I click "Save Epub"
             Then I expect to see "EPUB was successfully updated."
             When I have opened the book "Oliver Twist"
             Then I should see the content "Cover Page" for the book
