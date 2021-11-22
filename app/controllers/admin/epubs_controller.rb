module Admin
  class EpubsController < Admin::ApplicationController
    def edit
      @book = Book.find(params[:book_id]).decorate
    end

    def update
      @book = Book.find(params[:book_id])
      zip_file = epub_params.fetch(:file)

      EpubExtractor.extract_epub(@book.storage, zip_file)

      redirect_to [:admin, @book],
                  flash: { notice: t('epub_was_successfully_updated') }
    end

    private

    def epub_params
      params.require(:epub).permit(%i[file])
    end
  end
end
