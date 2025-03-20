# frozen_string_literal: true

class User::UsersController < User::ApplicationController
  def index
    @keyword = params[:q]

    if @keyword.blank?
      redirect_to root_path
      return
    end

    @users = User.search_by_keyword(@keyword)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.timeline_posts(bottom_cursor: params[:bottom_cursor])
    @bottom_cursor = @posts.last&.id

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "user_timeline_load_older",
          partial: "user/users/posts",
          locals: {
            posts: @posts,
            current_user: current_user,
            bottom_cursor: @bottom_cursor
          }
        )
      end
    end
  end
end
