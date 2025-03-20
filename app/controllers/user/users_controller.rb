# frozen_string_literal: true

class User::UsersController < User::ApplicationController
  before_action :find_user, only: %i[show timeline]

  def index
    @keyword = params[:q]

    redirect_back fallback_location: user_home_path if @keyword.blank?

    # TODO: ページネーション対応
    @users = User.search_by_keyword(@keyword)
  end

  def show
    @posts = @user.timeline_posts
    @bottom_cursor = @posts.last&.id
  end

  def timeline
    @posts = @user.timeline_posts(bottom_cursor: params[:bottom_cursor])
    @bottom_cursor = @posts.last&.id

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

  private

    def find_user
      @user = User.find(params[:id])
    end
end
