require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  def setup
    @question = Question.new(title: "new title", user: users(:guojing))
  end

  test "valid model should be valid" do
    assert @question.valid?
  end

  test "model without title should not be valid" do
    @question.title = nil
    assert_not @question.valid?
  end

  test "model with title that is too long should not be valid" do
    @question.title = "a" * (Question::TITLE_LENGTH_MAX + 1)
    assert_not @question.valid?
  end

  test "model without user should not be valid" do
    @question.user = nil
    assert_not @question.valid?
  end

end
