# frozen_string_literal: true

class User::UsersController < User::ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.timeline_posts
  end
end
