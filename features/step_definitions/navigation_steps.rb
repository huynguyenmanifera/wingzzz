When('I open the application') { visit '/' }

When('I visit {string}') { |path| visit path }

When('I have opened the application') { step 'I open the application' }

# This step is copied from https://github.com/makandra/spreewald
# which has some nice cucumber helpers. So if I catch myself on copied
# from this repo more often, we should consider using them gem itself.
When %r{^I perform basic authentication as "([^\"]*)/([^\"]*)" and go to "([^\"]*)"$} do |user, password, path|
  if javascript_capable?
    server =
      begin
        Capybara.current_session.server
      rescue StandardError
        Capybara.current_session.driver.rack_server
      end
    visit("http://#{user}:#{password}@#{server.host}:#{server.port}#{path}")
  else
    authorizers = [
      (page.driver.browser if page.driver.respond_to?(:browser)),
      self,
      page.driver
    ].compact
    authorizer = authorizers.detect { |a| a.respond_to?(:basic_authorize) }
    authorizer.basic_authorize(user, password)
    visit path
  end
end

Then('I should be redirected to the home page') do
  expect(current_path).to eql(root_path)
end

When('I use the left arrow key') do
  find('body').send_keys :left
  sleep 0.1
end

When('I use the right arrow key') do
  find('body').send_keys :right
  sleep 0.1
end

When('I use the right arrow key {int} times') do |int|
  int.times { step 'I use the right arrow key' }
end

When('I navigate to the books overview') { visit '/books' }

Then('I expect to be on the account page') do
  expect(current_path).to eql(account_path)
end
