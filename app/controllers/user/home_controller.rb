# frozen_string_literal: true

class User::HomeController < User::ApplicationController
  def index
    @posts = current_user.home_timeline_posts(
      top_cursor: params[:top_cursor],
      bottom_cursor: params[:bottom_cursor]
    )
    @top_cursor = next_top_cursor
    @bottom_cursor = next_bottom_cursor

    respond_to do |format|
      format.html
      format.turbo_stream { render_index_turbo_stream }
    end
  end

  private

    def request_newer_posts?
      params[:top_cursor].present?
    end

    def request_older_posts?
      params[:bottom_cursor].present?
    end

    def next_top_cursor
      if request_newer_posts?
        # 新着取得リクエストの場合、新着投稿があればその投稿IDを、なければ現在のトップカーソルを返す
        @posts.first&.id || params[:top_cursor]
      elsif request_older_posts?
        nil
      else
        @posts.first&.id
      end
    end

    def next_bottom_cursor
      request_newer_posts? ? nil : @posts.last&.id
    end

    def render_index_turbo_stream
      turbo_streams = [
        turbo_stream.replace(
          "home_timeline_load_#{request_older_posts? ? "older" : "newer"}",
          partial: "user/home/posts",
          locals: {
            posts: @posts,
            current_user: current_user,
            top_cursor: @top_cursor,
            bottom_cursor: @bottom_cursor
          }
        )
      ]

      if @top_cursor && @top_cursor != params[:top_cursor]
        turbo_streams << turbo_stream.replace(
          "home_timeline_refresh",
          partial: "user/home/refresh_timeline",
          locals: { top_cursor: @top_cursor }
        )
      end

      render turbo_stream: turbo_streams
    end
end
