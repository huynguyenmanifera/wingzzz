module Books
  class CoverImageComponent < ViewComponent::Base
    attr_reader :width, :height

    def initialize(book:, width: 200, height: 255)
      @book = book
      @width = width
      @height = height
    end

    def cover_url
      @book.cover.thumbnail.url
    end
  end
end
