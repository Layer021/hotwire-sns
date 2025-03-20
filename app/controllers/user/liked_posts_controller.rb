# frozen_string_literal: true

class User::LikedPostsController < User::ApplicationController
  before_action :find_post

  def create
    current_user.like_post(@post)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream { render_turbo_stream }
    end
  end

  def destroy
    current_user.unlike_post(@post)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream { render_turbo_stream }
    end
  end

  private

    def find_post
      @post = Post.find(params[:id])
    end

    def render_turbo_stream
      render turbo_stream: turbo_stream.replace(@post, partial: "shareds/post", locals: {
        post: @post,
        has_been_liked: @post.has_been_liked_by?(current_user),
        show_delete_button: @post.user == current_user
      })
    end
end
