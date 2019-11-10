require 'test_helper'

class LikingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @post = posts(:tone)
    @other_post = posts(:ants)
    log_in_as(@user)
  end

  test "liked page" do
    get user_path(@user)
    assert_not @user.like_posts.empty?
    @user.like_posts.each do |post|
      assert_select 'a[href=?]', user_path(post.user)
    end
  end

  test "like a post with standard way" do
    assert_difference -> { @user.like_posts.count },1 do
      post likes_path, params: {post_id: @other_post.id}
    end
  end

  test "like a post with Ajax" do
    assert_difference -> { @user.like_posts.count },1 do
      post likes_path, params: {post_id: @other_post.id}, xhr: true
    end
  end

  test "unlike a post with standard way" do
    @user.like(@other_post)
    like = @user.active_likes.find_by(post_id: @other_post.id)
    assert_difference -> { @user.like_posts.count },-1 do
      delete like_path(like)
    end
  end

  test "unlike a post with Ajax" do
    @user.like(@other_post)
    like = @user.active_likes.find_by(post_id: @other_post.id)
    assert_difference -> { @user.like_posts.count },-1 do
      delete like_path(like), xhr: true
    end
  end


end
