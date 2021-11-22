module Auth
  class RegistrationsController < Devise::RegistrationsController
    # rubocop:disable Rails/LexicallyScopedActionFilter
    prepend_before_action :require_no_authentication,
                          only: %i[new_teacher create_teacher new create cancel]
    # rubocop:enable Rails/LexicallyScopedActionFilter
    before_action -> { @mobile_friendly = true }
    before_action :build_teacher, only: %i[create_teacher]

    def new_teacher
      build_resource
      yield resource if block_given?
      respond_with resource
      @headline = 'Teacher sign up'
    end

    def create_teacher
      if resource.persisted?
        if resource.active_for_authentication?
          authenticate_teacher
        else
          inactive_signup_for_teacher
        end
      else
        reset_teacher_signup
      end
    end

    def success
      tracker { |t| t.google_tag_manager :push, { 'event' => 'signup' } }

      flash.discard
    end

    protected

    def after_inactive_sign_up_path_for(_resource)
      users_sign_up_success_path(locale: I18n.locale)
    end

    def reset_teacher_signup
      clean_up_passwords resource
      set_minimum_password_length
      invalid_sign_up_for_teacher(resource)
    end

    def authenticate_teacher
      flash[:notice] = :signed_up
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    end

    def inactive_signup_for_teacher
      flash[:notice] = :"signed_up_but_#{resource.inactive_message}"
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    end

    def invalid_sign_up_for_teacher(resource)
      respond_with(resource) { |format| format.html { render 'new_teacher' } }
    end

    def build_teacher
      @school = School.create_from_brin_code(school_params)
      build_resource(sign_up_params)
      resource.school = @school
      resource.save
      resource.add_role(:teacher)
    end

    def school_params
      return unless params.key?(:user) && params[:user].key?(:school)

      user_params = params[:user]
      user_params.require(:school).permit(
        :name,
        :address,
        :city,
        :postcode,
        :brin_code
      )
    end
  end
end
