require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  test "should create model" do
    post users_url, params: { user: { email: "test@bigfish.com", password: "AbCdEf", name: "Wang Chongyang", avatar_url: "http://www.google.com", description: "Guess we can!" } }

    assert_response :created
  end

  test "should not create model without user" do
    post users_url

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: 'missing_field', field: 'user' }], json_response['errors'])
  end

  test "should not create model without email" do
    post users_url, params: { user: { password: "AbCdEf", name: "Wang Chongyang" } }

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: 'missing_field', field: 'user:email' }], json_response['errors'])
  end

  test "should not create model with invalid email format" do
    post users_url, params: { user: { email: "invalid@email-format", password: "AbCdEf", name: "Wang Chongyang" } }

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: 'invalid_field', field: 'user:email' }], json_response['errors'])
  end

end
