module Auth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :fetch_user, only: %i[google_oauth2 facebook]

    def facebook
      provider_sign_in 'Facebook'
    end

    def google_oauth2
      provider_sign_in 'Google'
    end

    def failure
      redirect_to root_path
    end

    private

    def provider_sign_in(provider)
      if @user.persisted?
        start_trial?
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.#{provider}_data"] =
          request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url,
                    alert: @user.errors.full_messages.join("\n")
      end
    end

    def fetch_user
      @user = User.from_omniauth(request.env['omniauth.auth'])
    end

    def start_trial?
      return if @user.subscription || @user.trial&.active? || @user.admin?

      Trials.start(@user)
    end
  end
end
