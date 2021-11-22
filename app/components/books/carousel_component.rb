module Books
  class CarouselComponent < ViewComponent::Base
    attr_reader :books, :show_preview, :item_type

    def initialize(books:, show_preview: true, item_type: :concise)
      @books = books
      @show_preview = show_preview
      @item_type = item_type
    end
  end
end
