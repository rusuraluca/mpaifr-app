class Profile < ApplicationRecord
  has_many_attached :images
  has_many :inquires, dependent: :destroy

  def age
    ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor if date_of_birth
  end
end
