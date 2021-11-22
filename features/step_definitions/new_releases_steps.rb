Then('I expect to see {int} new releases') do |books_count|
  within_new_releases { expect(page).to have_css('li', count: books_count) }
end

Then('I expect to see {string} as the first new release') do |book_title|
  within_new_releases { expect(first('li img')[:title]).to eql(book_title) }
end

Then('I do not expect to see {string} as a new release') do |book_title|
  within_new_releases do
    expect(page).not_to have_css("li img[title=\"#{book_title}\"]")
  end
end
