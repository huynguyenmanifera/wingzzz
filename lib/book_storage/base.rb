module BookStorage
  class Base
    def initialize(book)
      @book = book
    end

    private

    def epub_path
      "uploads/book/epub/#{@book.slug}"
    end
  end
end
