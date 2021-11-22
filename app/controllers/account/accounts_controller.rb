module Account
  class AccountsController < ApplicationController
    def unsubscribe
      current_user.unsubscribe
      UserMailer.with(user: current_user).unsubscribe_email.deliver_later
      redirect_to action: :show
    end
  end
end
