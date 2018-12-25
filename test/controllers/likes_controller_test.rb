require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  
  test "should create like if not exist" do
    post question_like_url(questions(:two)), headers: login_as(:guojing)

    assert_response :created
  end

  test "should not create like if exist" do
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

end
