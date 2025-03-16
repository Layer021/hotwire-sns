class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { maximum: 200 }

  def has_been_liked_by?(user)
    likes.where(user: user).exists?
  end
end
