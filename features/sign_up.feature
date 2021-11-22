@javascript
Feature: Sign up
              As a parent
              I would like to sign up
  So I can access books

        Scenario: Redirect to sign in form when not authenticated
             When I open the application
             Then I should be on the sign in page

        Scenario: Sign up
            Given I have opened the application
              And today is "November 5 1955"
             When I click on sign up
              And I submit my account details
      """
      john.doe@example.org
      mYp@ssw0rd!
      mYp@ssw0rd!
      """
             Then I expect to see "Thank you for signing up with us"
             Then "john.doe@example.org" should receive an email
             When I open the email
              And I follow "Confirm my account" in the email
             Then I should be redirected to the home page
              And I should be authenticated
              And I should see that I have 14 days left in my trial period
             When "john.doe@example.org" opens the email with subject "Welcome to Wingzzz"
              And I should see "Thanks for signing up for the Wingzzz community. We’re so happy you’re here." in the email body
              And I should see "on: November 19, 1955." in the email body

        Scenario: Activate subscription
            Given today is "November 5 1955"
              And I have opened the application and signed in as trial user "john.doe@example.org" "f4kep@sSw0rD!"
              And I click on the trial link
             When I continue setting up my subscription
              And I submit my payment details
              And Mollie returns me to the Wingzzz application
             Then I should be redirected to the home page
              And I should be authenticated
              And I should not see a link to activate my subscription anymore
             When "john.doe@example.org" opens the email with subject "Thank you for subscribing to Wingzzz"
              And I should see "Your next payment will be billed on December 19, 1955." in the email body

        Scenario: Abort sign up process on payment page
            Given I have opened the application
             When I click on sign up
              And I submit my account details
      """
      john.doe@example.org
      mYp@ssw0rd!
      mYp@ssw0rd!
      """
              And "john.doe@example.org" should receive an email
              And I open the email
              And I follow "Confirm my account" in the email
              And I click on the trial link
              And I continue setting up my subscription
             When I abort when on the payment page
              And I open the application
              And I click on the trial link
             Then I expect to see a page telling me I was setting up my subscription
             When I continue setting up my subscription
              And I submit my payment details
              And Mollie returns me to the Wingzzz application
             Then I should be redirected to the home page
              And I should be authenticated

        Scenario: Cancel subscription flow
            Given I have opened the application
              And I click on sign up
              And I submit my account details
      """
      john.doe@example.org
      mYp@ssw0rd!
      mYp@ssw0rd!
      """
              And "john.doe@example.org" should receive an email
              And I open the email
              And I follow "Confirm my account" in the email
              And I click on the trial link
             When I cancel my subscription flow
             Then I should be on the sign in page
