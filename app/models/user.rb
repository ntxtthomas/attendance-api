class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist if defined?(JwtDenylist)
  has_many :attendance_entries, dependent: :nullify

  
end
