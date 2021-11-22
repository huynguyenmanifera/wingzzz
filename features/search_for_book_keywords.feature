@javascript
Feature: Search for book keywords
  As a parent, I can search for a specific book by entering a keyword that describes the book in the Wingzzz library so I can quickly find the book I want.

  Background:
    Given the following books:
      | title                            | slug      | language | keyword_list |
      | Robinson Crusoe                  | epub_test | en       | island       |
      | Alice's Adventures in Wonderland | epub_test | en       |              |
      | The Adventures of Tom Sawyer     | epub_test | en       |              |
      | Alice in Wonderland              | epub_test | nl       |              |


  Scenario: Submit query in search box to find book by keyword
    When I have opened the application and signed in
    And I have set my content language to 'English'
    Then I do not expect to see search results section
    And I enter "island" in the search bar and press enter
    Then I should see the following search results:
        | title                             |
        | Robinson Crusoe                   |
      But I should not see the following search results:
        | title                             |
        | Alice in Wonderland               |
        | Alice's Adventures in Wonderland  |
        | The Adventures of Tom Sawyer      |
