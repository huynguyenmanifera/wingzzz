@javascript
Feature: Search for book title
  As a parent, I can search for a specific book in the Wingzzz library so I can quickly find the book I want.

  Background:
    Given the following books:
      | title                            | slug      | language |
      | Robinson Crusoe                  | epub_test | en       |
      | Alice's Adventures in Wonderland | epub_test | en       |
      | The Adventures of Tom Sawyer     | epub_test | en       |
      | Alice in Wonderland              | epub_test | nl       |

  Scenario: Submit query in search box to find book by title
    When I have opened the application and signed in
    And I have set my content language to 'English'
    Then I do not expect to see search results section
    And I enter "advent" in the search bar and press enter
    Then I should see the following search results:
      | title                             |
      | Alice's Adventures in Wonderland  |
      | The Adventures of Tom Sawyer      |
    But I should not see the following search results:
      | title                             |
      | Robinson Crusoe                   |
      | Alice in Wonderland               |

  Scenario: Search for book available in different language
    When I have opened the application and signed in
    And I have set my content language to 'English'
    And I enter "Alice in Wonderland" in the search bar and press enter
    Then I should see the following search results:
      | title                             |
      | Alice in Wonderland               |
    But I should not see the following search results:
      | title                             |
      | Alice's Adventures in Wonderland  |
      | Robinson Crusoe                   |
      | The Adventures of Tom Sawyer      |
