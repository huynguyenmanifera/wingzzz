class ProfilesController < ApplicationController
  def update
    helpers.current_profile.update(profile_params)

    redirect_to books_url
  end

  private

  def profile_params
    return default_params if params[:reset]

    params.require(:profile).permit(
      :min_age_in_months,
      :max_age_in_months,
      :content_language
    )
  end

  def default_params
    {
      min_age_in_months: nil,
      max_age_in_months: nil,
      content_language: I18n.locale
    }
  end
end
