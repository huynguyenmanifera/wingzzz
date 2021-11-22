module Auth
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      super { |user| Trials.start(user) }
      flash.delete(:notice)
    end

    private

    def after_confirmation_path_for(_resource_name, resource)
      sign_in(resource)
      root_path
    end
  end
end
