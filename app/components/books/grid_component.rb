module Books
  class GridComponent < ViewComponent::Base
    attr_reader :books
    def initialize(books:)
      @books = books

      @book_width = 200
      @book_height = 255
      @column_gap = 32
      @row_gap = 1.5
    end

    private

    def ul_attributes
      { style: ul_style, data: { model: 'books' } }
    end

    def ul_style
      {
        display: 'grid',
        'grid-template-columns':
          "repeat(auto-fit, #{@book_width + @column_gap}px)",
        'grid-row-gap': "#{@row_gap}rem"
      }.reduce('') { |style, (k, v)| style << "#{k}: #{v}; " }
    end
  end
end
