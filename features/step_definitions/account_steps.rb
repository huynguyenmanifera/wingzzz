When("I navigate to 'My account'") { click_link 'My account' }

When("I click on 'Edit settings'") { click_link 'Edit settings' }

When('I change user language to {string}') do |language|
  select language, from: 'user[locale]'
end

When('I unsubscribe') do
  # Do not use `accept_confirm` here - I suspect
  # that this starts a separate thread which
  # doesn't seem to know anything about the stubbed DELETE
  # request to Mollie.
  click_on_and_confirm 'Cancel subscription'
end

When("I click on 'Save'") { click_button 'Save' }

Then('I expect to see a button to unsubscribe') do
  expect(page).to have_button('Cancel subscription')
end

Then('I expect not to see a button to unsubscribe') do
  expect(page).not_to have_button('Cancel subscription')
end
