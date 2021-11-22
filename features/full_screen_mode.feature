@javascript
@headlessUnsupported
Feature: Full screen mode
  As a parent, I would like to read a book in full screen mode, so I do not see the UI of the OS/browser and have a more immersive experience.

  Background:
    Given the following books:
      | title                            | has_epub | reader   | epub_with_page_images |
      | Seven little pigs                     | false    | animated | true                  |
      | The legend of Monte Cristo | true     | default  | false                 |
    And the following users:
      | email                | password      |
      | john.doe@example.org | f4kep@sSw0rD! |

  Scenario: Enter full screen mode
    When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "The legend of Monte Cristo"
    Then I should not see the application in fullscreen
    And I activate the menu
    And I click on the enter fullscreen icon
    Then I should see the application in fullscreen

  Scenario: Exit full screen mode
    When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "The legend of Monte Cristo"
    Then I should not see the application in fullscreen
    And I activate the menu
    And I click on the enter fullscreen icon
    Then I should see the application in fullscreen
    And I activate the menu
    And I click on the exit fullscreen icon
    Then I should not see the application in fullscreen

  Scenario: Enter full screen mode in animated reader
    When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "Seven little pigs"
    Then I should not see the application in fullscreen
    And I activate the menu in the animated reader
    And I click on the enter fullscreen icon
    Then I should see the application in fullscreen
    And I activate the menu in the animated reader
    And I click on the exit fullscreen icon
    Then I should not see the application in fullscreen

  Scenario: Exit full screen mode in animated reader
    When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
    And I am reading the book "Seven little pigs"
    Then I should not see the application in fullscreen
    And I activate the menu in the animated reader
    And I click on the enter fullscreen icon
    Then I should see the application in fullscreen
    And I activate the menu in the animated reader
    And I click on the exit fullscreen icon
    Then I should not see the application in fullscreen

