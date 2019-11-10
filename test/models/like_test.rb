require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @like = Like.new(user_id: users(:michael).id,
                      post_id: posts(:ants).id)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "should require user_id" do
    @like.user_id = nil
    assert_not @like.valid?
  end

  test "should require post_id" do
    @like.post_id = nil
    assert_not @like.valid?
  end
end
