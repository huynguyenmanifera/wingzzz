@javascript
@headlessUnsupported
Feature: Animated reader switch pages with progressbar dragging
  As a user I would like to be able to switch between pages of a book by dragging the mark on the progressbar

        Background:
            Given the following books:
                  | title                            | has_epub  | language  | reader    | epub_with_page_images |
                  | Oliver Twist                     | false     | en        | animated  | true                  |
              And the following users:
                  | email                | password      |
                  | john.doe@example.org | f4kep@sSw0rD! |
        
        Scenario: Switch pages by progressbar dragging
             When I have opened the application and signed in as "john.doe@example.org" "f4kep@sSw0rD!"
              And I am reading the book "Oliver Twist"
              And I activate the menu in the animated reader
             Then I drag progress by 50%
             And I activate the menu in the animated reader
             Then I do not expect to see "1 of 9"
