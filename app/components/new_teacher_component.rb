class NewTeacherComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(user:)
    @user = user.decorate
  end
end
