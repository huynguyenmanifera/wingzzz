Then(
  'I should see that I have {int} days left in my trial period'
) do |days_left|
  step 'I should see a link to activate my subscription'
  expect(page).to have_link("#{days_left} days left in trial")
end

Then('I should see a link to activate my subscription') do
  expect(page).to have_selector('a', text: /days left in trial/)
end

Then('I should not see a link to activate my subscription anymore') do
  expect(page).not_to have_selector('a', text: /days left in trial/)
end
