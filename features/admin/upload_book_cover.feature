@javascript
Feature: Upload book cover
  As a content manager, I want to be able to upload the cover for a book

  Background:
    Given the following books:
      | title           | has_cover      |
      | Oliver Twist    | false          |

  Scenario: Upload book cover
    Given I have opened the application and signed in as admin
    And I navigate to the admin panel
    Then I expect to see "Oliver Twist"
    When I click "Oliver Twist"
    Then I expect to see a default book cover image
    And I click "Edit book"
    And I attach cover image "spec/fixtures/cover/image.png"
    And I click "Update Book"
    Then I expect to see "Book was successfully updated."
    And I expect to see book cover image

