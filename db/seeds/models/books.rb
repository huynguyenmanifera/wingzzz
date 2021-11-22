# This does not remove the EPUB folder!
Book.destroy_all

publishers = Publisher.all

puts '***** Adding books *****'

I18n.available_locales.each do |locale|
  book =
    create(
      :book,
      :has_cover,
      :has_epub,
      title: "'#{locale.upcase}' book with EPUB", language: locale
    )
  puts "[Book] Adding '#{book.title}'"

  book =
    create(
      :book,
      :has_cover,
      :has_epub,
      :has_audio,
      title: "'#{locale.upcase}' book with EPUB and audio", language: locale
    )
  puts "[Book] Adding '#{book.title}'"
end

100.times do
  book = create(:book, :has_cover, publisher: publishers.sample)
  puts "[Book] Adding '#{book.title}'"
end
