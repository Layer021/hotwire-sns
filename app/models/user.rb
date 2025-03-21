# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :recoverable:confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  has_many :liked_post_relationships,
            class_name: "LikedPost",
            dependent: :destroy

  # いいねした投稿
  has_many :liked_posts,
           through: :liked_post_relationships,
           source: :post

  has_many :following_relationships,
           class_name: "FollowingUser",
           foreign_key: "user_id",
           dependent: :destroy

  has_many :follower_relationships,
           class_name: "FollowingUser",
           foreign_key: "following_user_id",
           dependent: :destroy

  # フォローしているユーザー
  has_many :followings,
           through: :following_relationships,
           source: :following_user

  # フォローされているユーザー
  has_many :followers,
           through: :follower_relationships,
           source: :user

  scope :search_by_keyword, ->(keyword) {
    where("users.name LIKE ?", "%#{keyword}%")
  }

  # ホーム画面用の投稿を取得する
  def home_timeline_posts(top_cursor: nil, bottom_cursor: nil)
    Post.eager_load(:user, :liked_users)
        .where(user: followings).or(Post.where(user: self))
        .order(id: :desc)
        .limit(50)
        .tap do |query|
          query.where!("posts.id > ?", top_cursor) if top_cursor
          query.where!("posts.id < ?", bottom_cursor) if bottom_cursor
        end
  end

  # ユーザー詳細画面用の投稿を取得する
  def timeline_posts(top_cursor: nil, bottom_cursor: nil)
    Post.eager_load(:user, :liked_users)
        .where(user: self)
        .order(id: :desc)
        .limit(50)
        .tap do |query|
          query.where!("posts.id > ?", top_cursor) if top_cursor
          query.where!("posts.id < ?", bottom_cursor) if bottom_cursor
        end
  end

  # 投稿をいいねする
  def like_post(post)
    liked_posts << post
  end

  # 投稿のいいねを解除する
  def unlike_post(post)
    liked_posts.destroy(post)
  end

  def has_been_followed_by?(user)
    followers.include?(user)
  end

  def follow(user)
    followings << user
  end

  def unfollow(user)
    followings.destroy(user)
  end
end
