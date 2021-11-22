When('I open my profile settings') { click_on 'Settings' }

When('I submit profile settings') do
  within('form.edit_profile') { click_on 'Save' }
end

When(
  'I have set my age restriction to {string} - {string}'
) do |min_age, max_age|
  step 'I open my profile settings'

  select min_age, from: 'profile[min_age_in_months]'
  select max_age, from: 'profile[max_age_in_months]'

  step 'I submit profile settings'
end

Then(
  'I expect my age restriction is saved as {string} - {string}'
) do |min_age, max_age|
  step 'I open my profile settings'

  expect(page).to have_select('profile[min_age_in_months]', selected: min_age)
  expect(page).to have_select('profile[max_age_in_months]', selected: max_age)
end

When('I have set my content language to {string}') do |content_language|
  step 'I open my profile settings'

  select content_language, from: 'profile[content_language]'

  step 'I submit profile settings'
end

Then('I expect my content language is saved as {string}') do |content_language|
  step 'I open my profile settings'

  expect(page).to have_select(
    'profile[content_language]',
    selected: content_language
  )
end
