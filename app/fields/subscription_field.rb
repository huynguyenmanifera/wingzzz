require 'administrate/field/base'

class SubscriptionField < Administrate::Field::Base
  include ActionView::Helpers::UrlHelper

  def to_s
    data&.aasm&.human_state
  end
end
