Given('the following books:') do |table|
  table.map_headers! do |header|
    case header
    when 'min_age_years'
      :min_age_in_months
    when 'max_age_years'
      :max_age_in_months
    else
      header
    end
  end
  table.map_column!('min_age_years', false) { |n| n.to_i * 12 }
  table.map_column!('max_age_years', false) { |n| n.to_i * 12 }
  table.map_column!('created_at', false) { |c| Chronic.parse(c) }

  table.hashes.each do |hash|
    has_cover = ActiveModel::Type::Boolean.new.cast(hash.delete('has_cover'))
    has_audio = ActiveModel::Type::Boolean.new.cast(hash.delete('has_audio'))
    epub_with_page_images =
      ActiveModel::Type::Boolean.new.cast(hash.delete('epub_with_page_images'))
    has_epub = ActiveModel::Type::Boolean.new.cast(hash.delete('has_epub'))
    time = hash.delete('created_at') || Time.current

    traits = []
    traits << :has_cover if has_cover
    traits << :has_audio if has_audio
    traits << :epub_with_page_images if epub_with_page_images
    traits << :has_epub if has_epub

    travel_to(time) { create(:book, *traits, hash) }
  end
end

Given('I am reading the book {string}') do |book_title|
  step "I have opened the book \"#{book_title}\""

  wait_until_full_epub_is_rendered
end

When('I have opened the {book}') do |book|
  step 'I have opened the application'
  visit book_path(book, locale: 'en')

  wait_until_full_epub_is_rendered
end

Then('I expect to see {int} books') do |books_count|
  within_library { expect(page).to have_css('li', count: books_count) }
end

Then('I should see the content {string} for the book on the left') do |content|
  within_an_epub_page(:left) { expect(page.body).to have_content(content) }
end

Then(
  'I should see the content {string} for the book on the right'
) do |content|
  within_an_epub_page(:right) { expect(page.body).to have_content(content) }
end

Then('I should see the content {string} for the book') do |content|
  step "I should see the content \"#{content}\" for the book on the left"
end

Then('I should not see the content {string} for the book') do |content|
  within_an_epub_page { expect(page.body).not_to have_content(content) }
end

Then('I do not expect to see any pages') do
  expect(epub_page_visible?).to be(false)
end

Then('I should be on the page for the {book}') do |book|
  expect(page).to have_current_path(book_path(book))
end

When('I open the book {string}') do |book_title|
  visit "/books/#{Book.find_by(title: book_title).id}"

  wait_until_full_epub_is_rendered
end

Then('I am on the book page of {string}') do |book_title|
  expect(page).to have_current_path(
    "/books/#{Book.find_by(title: book_title).id}",
    ignore_query: true
  )
end

When('I turn {int} pages') do |int|
  step "I use the right arrow key #{int} times"
end

When('I activate the menu') do
  if page.has_css?('#reader-navbar-top', visible: true)
    # Menu is already visible
    # Reactivate it to ensure it will stay activated
    # for the next few seconds
    find('#reader-navbar-top').click
  end

  find('#reader-navbar-top', visible: :all).click
end

When('I activate the menu in the animated reader') do
  find('.fbook-bottom-toolbar').click if page.has_css?('.fbook-bottom-toolbar')

  find('.fbook-bottom-toolbar', visible: :all).click
end

When('I activate the top toolbar in the animated reader') do
  find('.fbook-top-toolbar').click if page.has_css?('.fbook-top-toolbar')

  find('.fbook-top-toolbar', visible: :all).click
end

When('I click on the exit arrow') { find('*[data-action="exit"]').click }

When('I click on the enter fullscreen icon') do
  find('*[data-action="enter-fullscreen"]').click
end

When('I click on the exit fullscreen icon') do
  find('*[data-action="exit-fullscreen"]').click
end

When('I click on the restart icon') { find('*[data-action="restart"]').click }

Then('I should see the application in fullscreen') do
  expect(app_is_in_full_screen?).to be(true)
end

Then('I should not see the application in fullscreen') do
  expect(app_is_in_full_screen?).to be(false)
end

Then('I should see a preview for the {book}') do |book|
  within('body > [data-controller="modal"]') do
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.summary)
    expect(page).to have_link('Read book')
  end
end

Then('I drag progress by 50%') { find('.slider-mark').drag_by(200, 0) }

Then('I clear cookies') { Capybara.reset_sessions! }
