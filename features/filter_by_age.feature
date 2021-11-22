Feature: Filter by age
  As a parent,
  I would like to set an age restriction,
  so the shown content is relevant for my child.

  Background:
    Given the following books:
      | title                     | language | min_age_years | max_age_years | # 0    1    2    3    4    5    6    7
      | Tried for Error           | en       | 0             | 1             | # <---->    ·    ·    ·    ·    ·    ·
      | Dream Boat                | en       | 0             | 2             | # <--------->    ·    ·    ·    ·    ·
      | 2938: Oasis               | en       | 0             | 3             | # <-------------->    ·    ·    ·    ·
      | Case of the Blue Boa      | en       | 0             | 5             | # <------------------------>    ·    ·
      | Mystery of the Ugly Baker | en       | 0             | 7             | # <---------------------------------->
      | The Devil's Bride         | en       | 2             | 3             | # ·    ·    <---->    ·    ·    ·    ·
      | Court of the Rogue        | en       | 2             | 5             | # ·    ·    <-------------->    ·    ·
      | To Hook a Star            | en       | 2             | 7             | # ·    ·    <------------------------>
      | The Spell in a Marsh      | en       | 3             | 4             | # ·    ·    ·    <---->    ·    ·    ·
      | Electric Touch            | en       | 3             | 5             | # ·    ·    ·    <--------->    ·    ·
      | The Dancing Statue        | en       | 3             | 7             | # ·    ·    ·    <------------------->
      | The Ember in the Chasm    | en       | 5             | 7             | # ·    ·    ·    ·    ·    <--------->
      | 2132: Armageddon          | en       | 6             | 7             | # ·    ·    ·    ·    ·    ·    <---->

  Scenario: Show unfiltered content
    When I have opened the application and signed in
    Then I expect to see 13 books

  @javascript
  Scenario: Show filtered content
    Given I have opened the application and signed in
    #                                                                 ·    ·    <-------------->    ·    ·
    When I have set my age restriction to "2 years" - "5 years"
    Then I should see the following books:
      | title                     |
      | 2938: Oasis               |
      | Case of the Blue Boa      |
      | Mystery of the Ugly Baker |
      | The Devil's Bride         |
      | Court of the Rogue        |
      | To Hook a Star            |
      | The Spell in a Marsh      |
      | Electric Touch            |
      | The Dancing Statue        |
    But I should not see the following books:
      | title                     |
      | Tried for Error           |
      | Dream Boat                |
      | The Ember in the Chasm    |
      | 2132: Armageddon          |

  @javascript
  Scenario: Set age restriction
    Given I have opened the application and signed in
    When I have set my age restriction to "2 years" - "5 years"
    Then I expect my age restriction is saved as "2 years" - "5 years"
