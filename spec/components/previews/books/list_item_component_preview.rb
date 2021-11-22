module Books
  class ListItemComponentPreview < ViewComponent::Preview
    layout 'preview'

    def with_preview
      self.show_preview = true
      render(Books::ListItemComponent.new(options))
    end

    def without_preview
      self.show_preview = false
      render(Books::ListItemComponent.new(options))
    end

    private

    attr_accessor :show_preview

    def options
      { book: book, show_preview: show_preview }
    end

    def book
      Book.first.decorate
    end
  end
end
