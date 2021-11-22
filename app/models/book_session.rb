class BookSession < ApplicationRecord
  belongs_to :profile
  belongs_to :book

  def self.for(book, profile)
    create_with(current_page: 1).find_or_create_by(book: book, profile: profile)
  end
end
