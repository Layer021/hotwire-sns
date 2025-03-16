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
    @posts = @user.timeline_posts
  end
end
