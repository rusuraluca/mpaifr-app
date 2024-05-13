class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  validates :email, presence: true, uniqueness: true

  after_create :assign_default_role

  private

  def assign_default_role
    self.add_role(:regular) if self.roles.blank?
  end
end
