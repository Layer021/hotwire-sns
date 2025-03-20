# frozen_string_literal: true

class User::FollowingUsersController < ApplicationController
  before_action :find_user

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream { render_turbo_stream }
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream { render_turbo_stream }
    end
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def render_turbo_stream
      render turbo_stream: [
        turbo_stream.replace(@user, partial: "shareds/user", locals: {
          user: @user,
          show_follow_button: true,
          has_been_followed: @user.has_been_followed_by?(current_user)
        }),
        turbo_stream.replace(current_user, partial: "shareds/user", locals: {
          user: current_user,
          show_follow_button: false,
          has_been_followed: false
        })
      ]
    end
end
