Then('I expect event {string} to be logged') do |event_type|
  expect(Ahoy::Event.where(name: event_type).count).to be >= 1
end
