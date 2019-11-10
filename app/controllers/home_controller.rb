class HomeController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @post = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      store_location
    end
  end

  def search
    if params[:home][:search].present?
      @posts = Post.where('LOWER(content) LIKE ?', "%#{params[:home][:search].downcase}%").paginate(page: params[:page])
      @users = User.where('LOWER(name) LIKE ?', "%#{params[:home][:search].downcase}%").paginate(page: params[:page])
    else
      @posts = Post.all.paginate(page: params[:page])
      @users = User.all.paginate(page: params[:page])
    end
  end
end
