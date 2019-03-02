require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest

  # ==========================
  # Action create
  # ==========================
  
  test "should create like if not exist" do
    post question_like_url(questions(:two)), headers: login_as(:guojing)

    assert_response :created
  end

  test "should not create like if exists" do
    post question_like_url(questions(:one)), headers: login_as(:guojing)

    assert_response :bad_request
    assert hash_included_unordered({
      errors: [
        {
          code: "duplicated_field",
          field: "like:user"
        }
      ]
    }, json_response)
  end

  test "should not like a non-existent question" do
    post question_like_url(1234567), headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should create like if not exist for answers" do
    post answer_like_url(answers(:two)), headers: login_as(:guojing)

    assert_response :created
  end

  test "should not create like if exists for answers" do
    post answer_like_url(answers(:one)), headers: login_as(:guojing)

    assert_response :bad_request
    assert hash_included_unordered({
      errors: [
        {
          code: "duplicated_field",
          field: "like:user"
        }
      ]
    }, json_response)
  end

  test "should not like a non-existent question for answers" do
    post answer_like_url(1234567), headers: login_as(:guojing)

    assert_response :not_found
  end

  # ==========================
  # Action destroy
  # ==========================

  test "should destroy if exists" do
    delete question_like_url(questions(:one)), headers: login_as(:guojing)

    assert_response :ok
  end

  test "should not destroy if not exist" do
    delete question_like_url(questions(:two)), headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should not destroy a like of a non-existent question" do
    delete question_like_url(1234567), headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should destroy if exists for answers" do
    delete answer_like_url(answers(:one)), headers: login_as(:guojing)

    assert_response :ok
  end

  test "should not destroy if not exist for answers" do
    delete answer_like_url(answers(:two)), headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should not destroy a like of a non-existent question for answers" do
    delete answer_like_url(1234567), headers: login_as(:guojing)

    assert_response :not_found
  end

end
