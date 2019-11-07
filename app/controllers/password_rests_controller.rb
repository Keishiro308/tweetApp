class PasswordRestsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_reset_mail
      flash[:info] = 'メールからパスワードをリセットしてください。'
      redirect_to root_url
    else
      flash[:danger] = 'メールの送信に失敗しました。'
      render 'new'
    end
  end

  def edit
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = 'パスワードがリセットされました。'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def check_expiration
      if @user.password_rest_expired?
        flash[:danger] = "このリンクは期限切れです。もう一度パスワードのリセットを要求してください。"
        redirect_to new_password_rest_url
      end
    end
end
