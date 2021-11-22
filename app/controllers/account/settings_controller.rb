module Account
  class SettingsController < ApplicationController
    def edit
      @user = current_user
    end

    def update
      current_user.update user_params
      redirect_to account_path
    end

    private

    def user_params
      params.require(:user).permit(%i[locale])
    end
  end
end
