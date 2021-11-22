class RedirectsController < ApplicationController
  def handle
    redirect_to user_signed_in? ? books_path : new_user_session_path
  end
end
