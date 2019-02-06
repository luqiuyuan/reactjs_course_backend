require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # ==========================
  # Action index
  # ==========================

  test "should show models" do
    get users_url

    assert_response :ok
    assert hash_included_unordered(
      {
        users: [
          { id: users(:guojing).id },
          { id: users(:huangrong).id }
        ]
      },
      json_response
    )
  end

  test "should not show models" do
    User.destroy_all

    get users_url

    assert_response :not_found
  end

  # ==========================
  # Action show
  # ==========================

  test "should show model" do
    get users_url + "/" + users(:guojing).id.to_s

    assert_response :ok
  end

  test "should not show model" do
    get users_url + "/1234567"

    assert_response :not_found
  end

  # ==========================
  # Action create
  # ==========================
  
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

  test "should not create model with duplicated email" do
    post users_url, params: { user: { email: users(:guojing).email, password: "AbCdEf", name: "Wang Chongyang", avatar_url: "http://www.google.com", description: "Guess we can!" } }

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: 'duplicated_field', field: 'user:email' }], json_response['errors'])
  end

  # ==========================
  # Action update
  # ==========================

  test "should update model" do
    patch users_url + "/" + users(:guojing).id.to_s, params: { user: { email: "updated@bigfish.com", password: "123456Cd", name: "Show Me the Change", avatar_url: "http://www.updated_avatar.com", description: "updated description" } }

    assert_response :ok
  end

  test "should not update model with invalid id" do
    patch users_url + "/1234567"

    assert_response :not_found
  end

  # ==========================
  # View SHOW
  # ==========================

  test "should show view SHOW" do
    get users_url + "/" + users(:guojing).id.to_s

    assert_response :ok
    assert hash_included_unordered(
      {
        user: {
          id: users(:guojing).id,
          email: users(:guojing).email,
          name: users(:guojing).name,
          avatar_url: users(:guojing).avatar_url,
          description: users(:guojing).description,
          created_at: users(:guojing).created_at.as_json,
          updated_at: users(:guojing).updated_at.as_json
        }
      },
      json_response
    )
  end

  # ==========================
  # View INDEX
  # ==========================

  test "should show view INDEX" do
    get users_url

    assert_response :ok
    assert hash_included_unordered(
      {
        users: [
          {
            id: users(:guojing).id,
            email: users(:guojing).email,
            name: users(:guojing).name,
            avatar_url: users(:guojing).avatar_url,
            description: users(:guojing).description,
            created_at: users(:guojing).created_at.as_json,
            updated_at: users(:guojing).updated_at.as_json
          },
          {
            id: users(:huangrong).id,
            email: users(:huangrong).email,
            name: users(:huangrong).name,
            avatar_url: users(:huangrong).avatar_url,
            description: users(:huangrong).description,
            created_at: users(:huangrong).created_at.as_json,
            updated_at: users(:huangrong).updated_at.as_json
          }
        ]
      },
      json_response
    )
  end

end
