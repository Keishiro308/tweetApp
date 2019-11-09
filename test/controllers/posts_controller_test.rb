require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:orange)
  end

  test "create post not logged in" do
    assert_no_difference 'Post.count' do
      post posts_path, params:{ post: {content: 'lorem ijno'}}
    end
    assert_redirected_to login_url
  end

  test "delete post not logged in" do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to login_url
  end

  test "delete post wrong user" do
    log_in_as(users(:michael))
    post = posts(:ants)
    assert_no_difference 'Post.count' do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end
end
