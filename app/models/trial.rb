class Trial < ApplicationRecord
  belongs_to :user

  def active?(today = Date.current)
    expires_after >= today
  end

  def expired?(today = Date.current)
    !active?(today)
  end

  def days_left(today = Date.current)
    diff = (expires_after - today).to_i + 1 # today is inclusive
    diff.negative? ? 0 : diff
  end
end
