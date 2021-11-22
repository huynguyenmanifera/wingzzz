module Books
  class ListItemComponent < ViewComponent::Base
    with_collection_parameter :book

    attr_reader :item_type, :show_preview

    def initialize(book:, show_preview: true, item_type: :concise)
      @book = book
      @show_preview = show_preview
      @item_type = item_type
    end

    def li_attributes
      { class: 'book-list-item' }.tap do |h|
        case item_type
        when :card
          h[:class] << ' mr-4'
        when :concise
          h[:class] << ' py-3 mr-8'
        end

        if show_preview
          h[:data] = { controller: 'book', action: 'click->book#open' }
        end
      end
    end

    def li_content_wrapper(&block)
      if show_preview
        tag.div(li_content_wrapper_options, &block)
      else
        link_to(@book, li_content_wrapper_options, &block)
      end
    end

    def li_content_wrapper_options
      case item_type
      when :card
        {
          class:
            'book-list-item__card cursor-pointer flex p-5 rounded-sm shadow-xl'
        }
      when :concise
        { class: 'book-list-item__thumbnail cursor-pointer shadow-lg' }
      end
    end

    def audio_icon
      case @book.book_type
      when 'narrated'
        'narrated_book'
      when 'audio_only'
        'audio_book'
      end
    end

    def read_button
      case @book.book_type
      when 'narrated'
        button_text = 'read_to_me'
        button_class = 'btn book-btn-blue'
      when 'audio_only'
        button_text = 'listen_now'
        button_class = 'btn book-btn-purple'
      else
        button_text = 'read_book'
        button_class = 'btn btn-primary'
      end

      link_to I18n.t(button_text), @book, class: button_class
    end
  end
end
