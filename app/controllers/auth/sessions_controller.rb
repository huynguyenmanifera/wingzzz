module Auth
  class SessionsController < Devise::SessionsController
    before_action -> { @mobile_friendly = true }

    skip_before_action :authenticate_subscription
    after_action :after_login, only: :create # rubocop:disable Rails/LexicallyScopedActionFilter

    protected

    def after_login
      tracker { |t| t.google_tag_manager :push, { 'event' => 'login' } }
    end

    def after_sign_in_path_for(_resource)
      # Do not pass locale here, as the locale
      # will be determined by the user's settings
      # after logging in
      root_path
    end

    def after_sign_out_path_for(_resource)
      # After logging out, we will not have access
      # to the user's settings and the session will
      # be cleared. Therefore we'll need to pass the
      # locale explicitely in order to retain the
      # locale.
      new_user_session_path(locale: I18n.locale)
    end
  end
end
