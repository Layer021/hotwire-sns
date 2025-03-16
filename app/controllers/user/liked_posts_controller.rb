# frozen_string_literal: true

class User::LikedPostsController < User::ApplicationController
  def create
    post = Post.find(params[:id])
    current_user.like_post(post)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    post = Post.find(params[:id])
    current_user.unlike_post(post)
    redirect_back(fallback_location: root_path)
  end
end
