Feature: Sign in
    As a parent, I would like to sign in, so I can access books.

    Scenario: Redirect to sign in form when not authenticated
        Given I have opened the application
            And I should be on the sign in page
            When I navigate to the books overview
            Then I should be on the sign in page

    Scenario: Use my browser language
        Given I have a browser set to 'nl'
            When I have opened the application
            Then I expect to see 'Inloggen'

    Scenario: Sign in with correct credentials will authenticate
        Given the following users:
                | email                | password      |
                | john.doe@example.org | f4kep@sSw0rD! |
            And I have opened the application
            And I submit credentials "john.doe@example.org" "f4kep@sSw0rD!"
            Then I should not be on the sign in page
            But I should be redirected to the home page

    Scenario: Sign in with incorrect credentials will not authenticate
        Given I have opened the application
            And I submit credentials "john.doe@example.org" "incorrectpass"
            Then I should be on the sign in page
