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

  # ホーム画面用の投稿を取得する
  def home_timeline_posts(latest_cursor: nil, oldest_cursor: nil)
    Post.where(user: followings).or(Post.where(user: self))
        .order(id: :desc)
        .limit(50)
        .tap do |query|
          query.where!("id < ?", latest_cursor) if latest_cursor
          query.where!("id > ?", oldest_cursor) if oldest_cursor
        end
  end

  # ユーザー詳細画面用の投稿を取得する
  def timeline_posts(latest_cursor: nil, oldest_cursor: nil)
    Post.where(user: self)
        .order(id: :desc)
        .limit(50)
        .tap do |query|
          query.where!("id < ?", latest_cursor) if latest_cursor
          query.where!("id > ?", oldest_cursor) if oldest_cursor
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
end
