require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @like = Like.new(likable: questions(:two), user: users(:guojing))
  end

  test "valid model should be valid" do
    assert @like.valid?
  end

  test "model without likable should not be valid" do
    @like.likable = nil
    assert_not @like.valid?
  end

  test "model without user should not be valid" do
    @like.user = nil
    assert_not @like.valid?
  end

  test "user and likable should be unique" do
    @like.save
    like = Like.new(likable: questions(:two), user: users(:guojing))
    assert_not like.save
  end

end
