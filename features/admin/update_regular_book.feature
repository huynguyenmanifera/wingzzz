@javascript
Feature: set type of book
    As a administrator, I want to be able to set type of book

    Background:
        Given the following books:
        | title           | book_type |
        | Oliver Twist    | narrated  |

    Scenario: regular book
        Given I have opened the application and signed in as admin
        And I navigate to the admin panel
        Then I expect to see "Oliver Twist"
        When I click "Oliver Twist"
        And I click "Edit"
        Then I expect to see book type is "Narrated"
        When I select book type to "Regular"
        And I click "Update Book"
        Then I expect to see "Book was successfully updated."
        And I expect to see book type is "Regular" in the book overview page
