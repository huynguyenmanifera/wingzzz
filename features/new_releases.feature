@javascript
Feature: Library page categories "New Releases"

        Scenario: Show "New Releases"
            Given the following books:
                  | title                            | language | created_at   |
                  | Robinson Crusoe                  | en       | 10 day ago   |
                  | Alice's Adventures in Wonderland | en       | 2 days ago   |
                  | Foolish With Flowers             | nl       | 2 days ago   |
                  | The Adventures of Tom Sawyer     | en       | 3 days ago   |
                  | Alice in Wonderland              | en       | 4 days ago   |
                  | Sheep Of Magic                   | en       | 32 days ago  |
                  | Snowman In The Mountains         | en       | 5 days ago   |
                  | Sheep Of Secrets                 | en       | 44 days ago  |
                  | Chickens Of Rain                 | en       | 14 days ago  |
                  | Bears And Sheep                  | en       | 47 days ago  |
                  | Lions And Little Dragons         | en       | 411 days ago |
                  | Statue Of Dreams                 | en       | 24 days ago  |
             When I have opened the application and signed in
              And I have set my content language to 'English'
             Then I expect to see 10 new releases
              And I expect to see "Alice's Adventures in Wonderland" as the first new release
              But I do not expect to see "Lions And Little Dragons" as a new release
              And I do not expect to see "Foolish With Flowers" as a new release
