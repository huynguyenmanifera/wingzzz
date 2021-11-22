# This is an addition to `email_steps.rb`
Then('I should see an email with the following body:') do |doc_string|
  sentences = doc_string.split("\n").map(&:strip)

  sentences.each do |sentence|
    step("I should see \"#{sentence}\" in the email body")
  end
end

Then(
  '{string} should see the email {string} with the following body:'
) do |email, subject, body|
  step("\"#{email}\" opens the email with subject \"#{subject}\"")
  step('I should see an email with the following body:', body)
end
