require 'test_helper'

class LikeTest < ActiveSupport::TestCase

  def setup
    @like = Like.new(likeable: questions(:two))
  end

  test "valid model should be valid" do
    assert @like.valid?
  end

  test "model without likeable should not be valid" do
    @like.likeable = nil
    assert_not @like.valid?
  end

end
