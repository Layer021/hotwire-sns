# frozen_string_literal: true

class User::PostsController < User::ApplicationController
  def create
    @post = current_user.posts.build(create_params)
    if @post.save
      redirect_to root_path, notice: 'Post was successfully created.'
    else
      redirect_to root_path, alert: 'Post was not created.'
    end
  end

  private

    def create_params
      params.require(:post).permit(:body)
    end
end
