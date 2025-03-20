# frozen_string_literal: true

class User::PostsController < User::ApplicationController
  def create
    @post = current_user.posts.build(create_params)
    success = @post.save

    respond_to do |format|
      flash_type = success ? :notice : :alert
      flash_message = success ? "投稿に成功しました" : "投稿に失敗しました"
      flash.now[flash_type] = flash_message

      format.html { redirect_to root_path }
      format.turbo_stream { render_create_turbo_stream(success) }
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    success = @post.destroy

    respond_to do |format|
      flash_type = success ? :notice : :alert
      flash_message = success ? "投稿を削除しました" : "投稿の削除に失敗しました"
      flash.now[flash_type] = flash_message

      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream { render_destroy_turbo_stream(success) }
    end
  end

  private

    def create_params
      params.require(:post).permit(:body)
    end

    def render_create_turbo_stream(success)
      status = success ? :created : :unprocessable_entity

      turbo_streams = [
        turbo_stream.update("flash", partial: "layouts/user/alert"),
        turbo_stream.replace("post_form", partial: "layouts/user/post_form", locals: {
          post: success ? Post.new : @post
        })
      ]

      if success
        turbo_streams << turbo_stream.prepend("home_timeline_load_newer", partial: "shareds/post", locals: {
          post: @post,
          has_been_liked: false,
          show_delete_button: true
        })
      end

      render turbo_stream: turbo_streams, status:
    end

    def render_destroy_turbo_stream(success)
      status = success ? :ok : :unprocessable_entity

      turbo_streams = [
        turbo_stream.update("flash", partial: "layouts/user/alert")
      ]
      turbo_streams << turbo_stream.remove("post_#{params[:id]}") if success

      render turbo_stream: turbo_streams, status:
    end
end
