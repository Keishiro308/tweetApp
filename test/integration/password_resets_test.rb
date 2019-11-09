require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password reset" do
    get new_password_rest_path
    assert_template 'password_rests/new'
    post password_rests_path, params:{ password_reset:{email: ' '}}
    assert_not flash.empty?
    assert_template 'password_rests/new'
    post password_rests_path, params: {password_reset:{email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    user = assigns(:user)
    get edit_password_rest_path(user.reset_token, email: "")
    assert_redirected_to root_url
    user.toggle!(:activated)
    get edit_password_rest_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    get edit_password_rest_path('wrong token', email: user.email)
    assert_redirected_to root_url
    get edit_password_rest_path(user.reset_token, email: user.email)
    assert_template 'password_rests/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    patch password_rest_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    patch password_rest_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    patch password_rest_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_rest_path
    post password_rests_path,params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_rest_path(@user.reset_token),
         params: { email: @user.email,
                   user: { password:              "foobar",
                           password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match "期限切れ", response.body
 end
end