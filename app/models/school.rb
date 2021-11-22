class School < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :postcode, presence: true
  validates :brin_code, presence: true, uniqueness: true

  has_many :users, dependent: :destroy

  def self.create_from_brin_code(school_params)
    if school_params[:brin_code].present?
      school = School.find_by(brin_code: school_params[:brin_code])
    end

    school ||=
      School.create(
        name: school_params['name'],
        address: school_params['address'],
        city: school_params['city'],
        brin_code: school_params['brin_code'].presence,
        postcode: school_params['postcode']
      )

    school
  end

  def school_subscription
    SchoolSubscription.find_by school_id: id
  end
end
