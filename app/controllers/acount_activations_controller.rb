class AcountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = '認証できました。'
      log_in user
      redirect_to user
    else
      flash[:danger] = '認証リンクが正しくありません。'
      redirect_to root_url
    end
  end
end
