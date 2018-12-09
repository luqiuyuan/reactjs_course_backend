require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

  def setup
    @answer = Answer.new( content: "New Content", question: questions(:one), user: users(:guojing) )
  end

  test "valid model should be valid" do
    assert @answer.valid?
  end

  test "model without content should not be valid" do
    @answer.content = nil
    assert_not @answer.valid?
  end

  test "model with content that is too long should not be valid" do
    @answer.content = "a" * (Answer::CONTENT_LENGTH_MAX + 1)
    assert_not @answer.valid?
  end

  test "model without question should not be valid" do
    @answer.question = nil
    assert_not @answer.valid?
  end

  test "model without answer should not be valid" do
    @answer.user = nil
    assert_not @answer.valid?
  end

end
