When('I click on the book {string}') do |book_title|
  within_library { first("li img[title=\"#{book_title}\"]").click }
end

Then('I should see the book {string}') do |book_title|
  within_library { expect(page).to have_css("img[title=\"#{book_title}\"]") }
end

Then('I should not see the book {string}') do |book_title|
  within_library do
    expect(page).not_to have_css("img[title=\"#{book_title}\"]")
  end
end

Then('I should see the book {string} as search result') do |book_title|
  within_search_results do
    expect(page).to have_css("img[title=\"#{book_title}\"]")
  end
end

Then('I should not see the book {string} as search result') do |book_title|
  within_search_results do
    expect(page).not_to have_css("img[title=\"#{book_title}\"]")
  end
end

Then('I do not expect to see search results section') do
  expect(search_results_visible?).to be(false)
end

Then(
  'I should see the book {string} after {string}'
) do |book_after, book_before|
  step "I should see the book \"#{book_before}\""
  step "I should see the book \"#{book_after}\""

  expect(page.body.index(book_before)).to be < page.body.index(book_after),
  lambda {
    "Expected book #{book_after} (position #{
      page.body.index(book_after)
    }) to be shown after book #{book_before} (position #{
      page.body.index(book_before)
    }) in #{page.body}"
  }
end

Then('I should see books in order') do |books_string|
  books = books_string.split("\n").map(&:strip)
  library_content = all('.library ul li img').map { |n| n[:title] }
  expect(library_content).to eql(books)
end

Then('I should see the following books:') do |table|
  table.rows.each do |row|
    row.each { |cell| step "I should see the book \"#{cell}\"" }
  end
end

Then('I should not see the following books:') do |table|
  table.rows.each do |row|
    row.each { |cell| step "I should not see the book \"#{cell}\"" }
  end
end

Then('I should see the following search results:') do |table|
  table.rows.each do |row|
    row.each do |cell|
      step "I should see the book \"#{cell}\" as search result"
    end
  end
end

Then('I should not see the following search results:') do |table|
  table.rows.each do |row|
    row.each do |cell|
      step "I should not see the book \"#{cell}\" as search result"
    end
  end
end

Then('I expect not to see a "Currently Reading" section') do
  expect(page).not_to have_css('.currently-reading')
end

When(
  'I click on the book {string} in the "Currently Reading" section'
) do |book_title|
  within_currently_reading { first("li img[title=\"#{book_title}\"]").click }
end

Then(
  'I expect to see the book {string} in the "Currently Reading" section'
) do |book_title|
  within_currently_reading do
    expect(page).to have_css("li img[title=\"#{book_title}\"]")
  end
end

When('I enter {string} in the search bar and press enter') do |query|
  fill_in 'filters[q]', with: query

  find('*[name="filters[q]"]').send_keys :return
end

Given('I click on the trial link') do
  btn = page.find('a', text: /days left in trial/)

  btn.click
end
