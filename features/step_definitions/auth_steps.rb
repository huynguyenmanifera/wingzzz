Given('the following users:') do |table|
  table.hashes.each { |hash| create(:user, :with_an_active_subscription, hash) }
end

Given('I have opened the application and signed in') do
  email = 'testing@man.net'
  password = 'secretpass'
  create(
    :user,
    :with_an_active_subscription,
    email: email, password: password, password_confirmation: password
  )

  step "I have opened the application and signed in as \"#{email}\" \"#{
         password
       }\""
end

Given('I have opened the application and signed in as admin') do
  email = 'admin@example.org'
  password = 'secretpass'
  create(
    :user,
    admin: true,
    email: email,
    password: password,
    password_confirmation: password
  )

  step "I have opened the application and signed in as \"#{email}\" \"#{
         password
       }\""
end

Given(
  'I have opened the application and signed in as {string} {string}'
) do |email, password|
  step 'I have opened the application'
  visit '/users/sign_in'
  step "I submit credentials \"#{email}\" \"#{password}\""
end

Given(
  'I have opened the application and signed in as trial user {string} {string}'
) do |email, password|
  create(
    :user,
    email: email, password: password, password_confirmation: password
  ) { |user| Trials.start(user) }

  step "I have opened the application and signed in as \"#{email}\" \"#{
         password
       }\""
end

Given('I am not authenticated') { visit('/users/sign_out') }

When('I sign out') do
  visit '/'
  step 'I click on sign out'
end

When('I click on sign out') { click_link 'Sign out' }

When('I sign in as {string} {string}') do |email, password|
  visit '/'
  step "I submit credentials \"#{email}\" \"#{password}\""
end

When('I submit credentials {string} {string}') do |email, password|
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  click_button 'Sign in'
end

Then('I should be on the sign in page') do
  expect(page).to have_current_path('/users/sign_in', ignore_query: true)
end

Then('I should not be on the sign in page') do
  expect(page).to_not have_current_path('/users/sign_in', ignore_query: true)
end

Then('I should not be authenticated') do
  visit '/'

  step 'I should be on the sign in page'
end

Then('I should be authenticated') do
  visit '/'

  step 'I should not be on the sign in page'
end
