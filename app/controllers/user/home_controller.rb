# frozen_string_literal: true

class User::HomeController < User::ApplicationController
  def index
    @posts = current_user.home_timeline_posts
  end
end
