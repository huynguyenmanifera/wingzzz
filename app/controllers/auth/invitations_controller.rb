module Auth
  class InvitationsController < Devise::InvitationsController
    before_action -> { @mobile_friendly = true }
    skip_before_action :authenticate_subscription
    after_action :add_school_roles, only: %i[create]
    after_action :add_school_details, only: %i[create]

    def create
      super
    end

    private

    def add_school_roles
      resource.add_role :teacher
      resource.add_role :school_subscription_member
    end

    def add_school_details
      resource.locale = current_user.locale
      resource.school_id = current_user.school_id
      resource.confirmation_token = nil
      resource.confirmed_at = DateTime.now
      resource.save
    end
  end
end
