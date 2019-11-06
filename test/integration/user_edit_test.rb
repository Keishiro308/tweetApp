require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: '',
                                            email: 'example@example',
                                            password: 'foo',
                                            password_confirmation: 'bar'}}
    assert_template 'users/edit'
    assert_select 'div.alert', '4つのエラーがあります。'
  end

  test "successful edit with friendly fowarding" do
    get edit_user_path(@user)
    assert_redirected_to login_url
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_nil session['fowarding_url']
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: {user: {name: name,
                                            email: email,
                                            password: '',
                                            password_confirmation: ''}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful destroy user" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select 'a[href=?]', user_path(@user), text: 'アカウント削除'
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
  end
end
