# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, class_name: "LikedPost", dependent: :destroy

  validates :body, presence: true, length: { maximum: 200 }

  def has_been_liked_by?(user)
    likes.where(user: user).exists?
  end
end
