require 'test_helper'

class AuthenticationTestingControllerTest < ActionController::TestCase

  # ==========================
  # Action authenticate
  # ==========================

  test "valid user token should be valid" do
    login_as :guojing

    get :authenticate

    assert_response :ok
  end

  test "should not pass without user token" do
    get :authenticate

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "invalid_user_token" }], json_response['errors'])
  end

  test "user token without user_id should not be valid" do
    # Setup user token
    user = users(:guojing)
    user_token = UserToken.new(user)
    user_token.save
    @request.headers['Authorization'] = '{"user_token":{"key":"' + user_token.key + '"}}'

    get :authenticate

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "invalid_user_token" }], json_response['errors'])
  end

  test "user token without key should not be valid" do
    # Setup user token
    user = users(:guojing)
    user_token = UserToken.new(user)
    user_token.save
    @request.headers['Authorization'] = '{"user_token":{"user_id":"' + user.id.to_s + '"}}'

    get :authenticate

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "invalid_user_token" }], json_response['errors'])
  end

  test "user token with non-existing user_id should not be valid" do
    # Setup user token
    user = users(:guojing)
    user_token = UserToken.new(user)
    user_token.save
    @request.headers['Authorization'] = '{"user_token":{"user_id":"1234567", "key":"' + user_token.key + '"}}'

    get :authenticate

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "invalid_user_token" }], json_response['errors'])
  end

  test "user token with non-existing key should not be valid" do
    # Setup user token
    user = users(:guojing)
    user_token = UserToken.new(user)
    user_token.save
    @request.headers['Authorization'] = '{"user_token":{"user_id":"' + user.id.to_s + '", "key":"Non-existing Key"}}'

    get :authenticate

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "invalid_user_token" }], json_response['errors'])
  end

end
