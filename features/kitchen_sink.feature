@javascript
Feature: Kitchen sink
  As a developer, I would like to see a kitchen sink page so I know which components are available and how to use tem.

  Scenario: Access kitchen sink
    When I have opened the application and signed in
    When I visit "/kitchen-sink"
    Then I expect to see "Kitchen Sink"
