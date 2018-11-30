require 'test_helper'

class UserTokensControllerTest < ActionDispatch::IntegrationTest

  test "should create user token" do
    post user_tokens_url, params: { credential: { email: users(:guojing).email, password: "guojing password" } }

    assert_response :created
  end

  test "should not create user token without invalid credential" do
    post user_tokens_url, params: { credential: { email: users(:guojing).email, password: "invalid password" } }

    assert_response :bad_request
  end

  test "should not create user token without credential" do
    post user_tokens_url

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: 'missing_field', field: 'credential' }], json_response['errors'])
  end

  test "should not create user token without credential:email" do
    post user_tokens_url, params: { credential: { password: "guojing password" } }

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: 'missing_field', field: 'credential:email' }], json_response['errors'])
  end

end
