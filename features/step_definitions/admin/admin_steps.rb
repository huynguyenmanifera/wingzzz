When('I navigate to the admin panel') { visit '/admin' }

When('I attach cover image {string}') do |path|
  attach_file('book[cover]', path)
end

When('I attach audio file {string}') { |path| attach_file('book[audio]', path) }

When('I attach EPUB file {string}') { |path| attach_file('epub[file]', path) }

Then('I expect to see a default book cover image') do
  thumbnail = page.find('[data-model="book-cover-image"]')
  expect(thumbnail[:style]).to_not include(
                                     'background-image: url(/images/fallback/thumbnail_default.jpg);'
                                   )
end

Then('I expect to see book cover image') do
  thumbnail = page.find('[data-model="book-cover-image"]')
  expect(thumbnail[:style]).to include('background-image')
end

Then('I expect to see an audio link') do
  audio = page.find('.attribute-data--file-uploader-field')
  expect(audio).to have_content('Link')
end

When('I unsubscribe user {string}') do |user_email|
  click_on user_email

  accept_confirm { click_on 'Unsubscribe' }
end

Then('I expect to see book type is {string}') do |book_type|
  book_input = page.find('#book_book_type')
  expect(book_input.value.downcase).to eq(book_type.downcase)
end

Then(
  'I expect to see book type is {string} in the book overview page'
) do |book_type|
  within '.main-content__body' do
    expect(page).to have_content(book_type)
  end
end

When('I select book type to {string}') do |book_type|
  select book_type, from: 'book[book_type]'
end
