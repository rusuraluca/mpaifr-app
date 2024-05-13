class Inquire < ApplicationRecord
  belongs_to :profile
  belongs_to :user

  has_many_attached :images

  enum status: { not_verified: 'Not Verified', solved: 'Solved', not_solved: 'Not Solved' }

  validates :date_taken, :city_taken, :country_taken, presence: true
end
