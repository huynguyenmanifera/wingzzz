class SchoolSubscription < ApplicationRecord
  validates :contact_name, presence: true
  validates :contact_email, presence: true
  validates :billing_name, presence: true
  validates :billing_address, presence: true
  validates :billing_city, presence: true
  validates :billing_brincode, uniqueness: true
  validates :end_date, presence: true

  belongs_to :school
  belongs_to :user

  def self.fill_billing_from_school(user)
    school = School.find_by id: user.school_id

    SchoolSubscription.new(
      billing_name: school.name,
      billing_address: school.address,
      billing_city: school.city,
      billing_postcode: school.postcode,
      billing_brincode: school.brin_code,
      school_id: school.id,
      user_id: user.id
    )
  end

  def active?
    Date.current <= end_date
  end
end
