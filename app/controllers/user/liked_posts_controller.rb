# frozen_string_literal: true

class User::LikedPostsController < User::ApplicationController
  before_action :find_post

  def create
    current_user.like_post(@post)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.unlike_post(@post)
    redirect_back(fallback_location: root_path)
  end

  private

    def find_post
      @post = Post.find(params[:id])
    end
end
