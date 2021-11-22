@javascript
Feature: Read a book (Minimal implementation)
  As a parent
  I would like to view a book (on my mobile device or laptop)
  So I can read to my child

  Background:
    Given the following books:
      | title                            | has_epub | layout      | reader   | epub_with_page_images |
      | Oliver Twist                     | false    | two_pages   | animated | true                  |
      | Alice's Adventures in Wonderland | true     | two_pages   | default  | false                 |
      | Single page book                 | true     | single_page | default  | false                 |

  Scenario: System shows EPUB file
    Given I have opened the application and signed in
    When I have opened the book "Alice's Adventures in Wonderland"
    Then I should see the content "Cover Page" for the book

  @headlessUnsupported
  Scenario: System shows book in animated reader by using full page images from the epub
    Given I have opened the application and signed in
    When I have opened the book "Oliver Twist"
    And I activate the menu in the animated reader
    Then I expect to see "0 of 9"

  Scenario: Use arrow keys to go to next page
    Given I have opened the application and signed in
    And I am reading the book "Alice's Adventures in Wonderland"
    When I use the right arrow key
    Then I should see the content "Donec Quis Nunc" for the book on the left
    And I should see the content "Omnis Iste Natur" for the book on the right
    But I should not see the content "Cover Page" for the book

  Scenario: Use arrow keys to go to previous page
    Given I have opened the application and signed in
    And I am reading the book "Alice's Adventures in Wonderland"
    And I use the right arrow key 3 times
    And I use the left arrow key
    Then I should see the content "Quis autem vel" for the book on the left
    And I should see the content "Donec conjectuur ac" for the book on the right

  @headlessUnsupported
  Scenario: Use arrow keys in animated reader to go to next page
    Given I have opened the application and signed in
    And I am reading the book "Oliver Twist"
    And I turn 2 pages
    And I activate the menu in the animated reader
    Then I expect to see "3 of 9"
    Then I do not expect to see "0 of 9"

  @headlessUnsupported
  Scenario: Use arrow keys in animated reader to go to previous page
    Given I have opened the application and signed in
    And I am reading the book "Oliver Twist"
    And I turn 2 pages
    And I use the left arrow key
    And I activate the menu in the animated reader
    Then I expect to see "1 of 9"
    Then I do not expect to see "3 of 9"

  Scenario: Reading a book with layout 'single_page' shows pages individually
    Given I have opened the application and signed in
    And I am reading the book "Single page book"
    Then I should see the content "Cover Page" for the book
    When I use the right arrow key
    Then I should see the content "Donec Quis Nunc" for the book
    When I use the right arrow key
    Then I should see the content "Omnis Iste Natur" for the book
    When I use the right arrow key
    Then I should see the content "Quis autem vel" for the book
