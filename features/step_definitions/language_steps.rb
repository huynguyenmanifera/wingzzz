Given('I have a browser set to {string}') do |language|
  page.driver.header 'Accept-Language', language
end

When('I switch language to {string}') { |locale| click_on locale }
