When('I click on sign up') { click_link 'Sign up' }

Then('I submit my account details') do |account_details|
  email, password, pass_confirmation = account_details.split("\n")

  sleep 0.2

  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  fill_in 'user_password_confirmation', with: pass_confirmation

  click_button 'Sign up'
end

Then('I expect to see a message to reset my password') do
  step 'I expect to see "You will receive an email in a few minutes with instructions on how to reset your password."'
end
