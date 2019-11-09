require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'ul.pagination'
    assert_select 'input[type = file]'
    assert_no_difference 'Post.count' do
      post posts_path, params: {post: {content: ''}}
    end
    assert_select 'div#error_explanation'
    content = 'hello world'
    picture = fixture_file_upload('test/fixtures/ダウンロード.jpeg', 'image/jpeg')
    assert_difference -> { Post.count }, 1 do
      post posts_path, params: {post: {content: content,
                                        picture: picture}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    assert_select 'a', text:'delete'
    first_post = Post.first
    assert_difference -> { Post.count }, -1 do
      delete post_path(first_post)
    end
    get user_path(users(:archer))
    assert_select 'a', text:'delete', count: 0
  end

  test "post count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.posts.count} 個の投稿", response.body
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 個の投稿", response.body
    other_user.posts.create!(content: 'hello')
    get root_path
    assert_match "#{other_user.posts.count} 個の投稿", response.body
  end
end
