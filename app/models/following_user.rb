# frozen_string_literal: true

class FollowingUser < ApplicationRecord
  belongs_to :user
  belongs_to :following_user, class_name: "User"
end
