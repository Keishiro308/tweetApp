require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'example user', email: 'user@example.com',
                      password: 'foobar', password_confirmation: 'foobar')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should not empty" do
    @user.name = ' '
    assert_not @user.valid?
  end

  test "email should not empty" do
    @user.email = ' '
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = 'a'*51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a'*244 + '@example.com'
    assert_not @user.valid?
  end

  test "should accept valid email addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address} should be valid."
    end
  end

  test "should reject invalid email addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid."
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = ' '*6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a'*5
    assert_not @user.valid?
  end

  test "when remember_digest is nil" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "when associated account destroy, posts also destroyed" do
    @user.save
    @user.posts.create!(content: 'lorem jkklk')
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed test" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    lana.posts.each do |post_follow|
      assert michael.feed.include?(post_follow)
    end
    michael.posts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    archer.posts.each do |post_unfollow|
      assert_not michael.feed.include?(post_unfollow)
    end
  end

  test "should like and unlike a post" do
    user = users(:michael)
    post = posts(:ants)
    assert_not user.like?(post)
    user.like(post)
    assert user.like?(post)
    assert post.liked_users.include?(user)
    user.unlike(post)
    assert_not user.like?(post)
  end
end
