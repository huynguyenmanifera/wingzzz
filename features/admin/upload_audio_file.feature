@javascript
Feature: Upload book audio
  As a content manager, I want to be able to upload the audio for a book

  Background:
    Given the following books:
      | title           | has_audio |
      | Oliver Twist    | false     |

  Scenario: Upload book audio
    Given I have opened the application and signed in as admin
    And I navigate to the admin panel
    Then I expect to see "Oliver Twist"
    When I click "Oliver Twist"
    And I click "Edit book"
    And I attach audio file "test/fixtures/audio/mpthreetest.mp3"
    And I click "Update Book"
    Then I expect to see "Book was successfully updated."
    And I expect to see an audio link
