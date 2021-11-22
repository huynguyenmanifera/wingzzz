class BooksController < ApplicationController
  include ApplicationHelper

  def index
    @mobile_reset = true
    set_search_results
    set_trending_now
    set_currently_reading
    set_recently_added
    set_book_collection
  end

  def show
    @mobile_fixed = true
    @book = Book.find(params[:id]).decorate
    @book_session = BookSession.for(@book, current_profile)
  end

  private

  def filter_params
    params[:filters]&.slice(:q)
  end

  def profile_params
    params.fetch(:profile, {}).permit(:min_age_in_months, :max_age_in_months)
  end

  def set_trending_now
    @trending_now =
      Book.where(language: current_profile.content_language).trending_now
        .decorate
  end

  def set_currently_reading
    @currently_reading =
      Book.includes(:publisher, :authors).currently_reading(current_profile)
        .decorate
  end

  def set_recently_added
    @recently_added =
      Book.includes(:publisher, :authors).where(
        language: current_profile.content_language
      )
        .recently_added
        .decorate
  end

  def set_book_collection
    @book_collection = BookCollection.from_filters(nil, current_profile)
  end

  def set_search_results
    @search_results =
      BookCollection.from_filters(filter_params, current_profile)
  end
end
