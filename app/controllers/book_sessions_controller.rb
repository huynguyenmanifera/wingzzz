class BookSessionsController < ApplicationController
  include ApplicationHelper

  def update
    @book = Book.find(params[:book_id])
    @book_session = BookSession.for(@book, current_profile)
    @book_session.update book_session_params
  end

  private

  def book_session_params
    params.require(:book_session).permit(%i[current_page])
  end
end
