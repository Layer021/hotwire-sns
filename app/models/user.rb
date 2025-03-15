class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :recoverable:confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable
end
