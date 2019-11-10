class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    respond_to do |format|
      format.html { redirect_back_or @post.user }
      format.js
    end
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
    respond_to do |format|
      format.html { redirect_back_or @post.user }
      format.js
    end
  end
end
