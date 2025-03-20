# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, class_name: "LikedPost", dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :body, presence: true, length: { maximum: 200 }

  def has_been_liked_by?(user)
    liked_users.include?(user)
  end
end
