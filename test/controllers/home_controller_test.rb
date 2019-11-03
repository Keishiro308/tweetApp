require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'TweetApp'
  end

  test "should get index" do
    get root_path
    assert_response :success
    assert_select "title", "Home|#{@base_title}"
  end

end
