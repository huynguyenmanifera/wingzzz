Then('I expect to see {string}') { |text| expect(page).to have_content(text) }

Then('I do not expect to see {string}') do |content|
  expect(page).not_to have_content(content)
end

When('I wait {int} seconds') { |int| sleep int }

Given('today is {string}') { |date_string| travel_to Date.parse(date_string) }

When('I click (the ){string}( button)') do |locator|
  click_link_or_button locator
end

AfterStep('@pause') do
  print 'Press Return to continue ...'
  STDIN.getc
end
