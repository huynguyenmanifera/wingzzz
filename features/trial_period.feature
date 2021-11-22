Feature: Trial period

        Scenario: Allow an admin without the need for a trial period
            Given I have opened the application and signed in as admin
             Then I should be redirected to the home page
