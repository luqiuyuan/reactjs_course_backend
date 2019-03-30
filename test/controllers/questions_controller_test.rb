require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest

  # ==========================
  # Action index
  # ==========================

  test "should show models" do
    get questions_url, headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404" do
    Question.destroy_all

    get questions_url, headers: login_as(:guojing)

    assert_response :not_found
  end

  # ==========================
  # Action show
  # ==========================

  test "should show model" do
    get questions_url + "/" + questions(:one).id.to_s, headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404 for show" do
    get questions_url + "/1234567", headers: login_as(:guojing)

    assert_response :not_found
  end

  # ==========================
  # Action create
  # ==========================

  test "should create model" do
    post questions_url, headers: login_as(:guojing), params: { question: { title: "New Title", content: "New Content" } };

    assert_response :created
  end

  test "should not create model without question" do
    post questions_url, headers: login_as(:guojing)

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "missing_field", field: "question" }], json_response['errors'])
  end

  test "should not create model with invalid question:title" do
    post questions_url, headers: login_as(:guojing), params: { question: { title: "a" * (Question::TITLE_LENGTH_MAX + 1), content: "New Content" } };

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "invalid_field", field: "question:title" }], json_response['errors'])
  end

  # ==========================
  # Action update
  # ==========================

  test "should update model" do
    patch questions_url + "/" + questions(:one).id.to_s, params: { question: { title: "New Title" } }, headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404 for update" do
    patch questions_url + "/1234567", params: { question: { title: "New Title" } }, headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should return 403" do
    patch questions_url + "/" + questions(:one).id.to_s, params: { question: { title: "New Title" } }, headers: login_as(:huangrong)

    assert_response :forbidden
  end

  # ==========================
  # Action destroy
  # ==========================

  test "should destroy model" do
    delete questions_url + "/" + questions(:one).id.to_s, headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404 for destroy" do
    delete questions_url + "/1234567", headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should return 403 for destroy" do
    patch questions_url + "/" + questions(:one).id.to_s, headers: login_as(:huangrong)

    assert_response :forbidden
  end

  # ==========================
  # View SHOW
  # ==========================

  test "should show view SHOW" do
    post questions_url, headers: login_as(:guojing), params: { question: { title: "New Title", content: "New Content" } };

    assert_response :created
    assert hash_included_unordered({
      question: {
        id: Question.last.id,
        title: "New Title",
        content: "New Content",
        user_id: users(:guojing).id,
        created_at: Question.last.created_at.as_json,
        updated_at: Question.last.updated_at.as_json,
        number_of_likes: Question.last.likes.size
      }
    }, json_response)
  end

  # ==========================
  # View INDEX
  # ==========================

  test "should show view INDEX" do
    get questions_url, headers: login_as(:guojing)

    assert_response :ok
    assert hash_included_array_unordered([
      {
        id: questions(:one).id,
        title: questions(:one).title,
        content: questions(:one).content,
        user_id: users(:guojing).id,
        created_at: questions(:one).created_at.as_json,
        updated_at: questions(:one).updated_at.as_json,
        number_of_likes: questions(:one).likes.size
      },
      {
        id: questions(:two).id,
        title: questions(:two).title,
        content: questions(:two).content,
        user_id: users(:guojing).id,
        created_at: questions(:two).created_at.as_json,
        updated_at: questions(:two).updated_at.as_json,
        number_of_likes: questions(:two).likes.size
      }
    ], json_response['questions'])
  end

  # ==========================
  # Field liked in View SHOW
  # ==========================

  test "should show field liked as true in view show" do
    get questions_url + "/" + questions(:one).id.to_s, headers: login_as(:guojing)

    assert_response :ok
    assert hash_included_unordered({
      question: {
        liked: true
      }
    }, json_response)
  end

  test "should show field liked as false in view show" do
    get questions_url + "/" + questions(:one).id.to_s, headers: login_as(:huangrong)

    assert_response :ok
    assert hash_included_unordered({
      question: {
        liked: false
      }
    }, json_response)
  end

  test "should show field liked as false in view show 2" do
    get questions_url + "/" + questions(:one).id.to_s

    assert_response :ok
    assert hash_included_unordered({
      question: {
        liked: false
      }
    }, json_response)
  end

  # ==========================
  # Field liked in View INDEX
  # ==========================

  test "should show field liked view INDEX 1" do
    get questions_url, headers: login_as(:guojing)

    assert_response :ok
    assert hash_included_array_unordered([
      {
        id: questions(:one).id,
        title: questions(:one).title,
        content: questions(:one).content,
        user_id: users(:guojing).id,
        created_at: questions(:one).created_at.as_json,
        updated_at: questions(:one).updated_at.as_json,
        number_of_likes: questions(:one).likes.size,
        liked: true
      },
      {
        id: questions(:two).id,
        title: questions(:two).title,
        content: questions(:two).content,
        user_id: users(:guojing).id,
        created_at: questions(:two).created_at.as_json,
        updated_at: questions(:two).updated_at.as_json,
        number_of_likes: questions(:two).likes.size,
        liked: false
      }
    ], json_response['questions'])
  end

  test "should show field liked view INDEX 2" do
    get questions_url

    assert_response :ok
    assert hash_included_array_unordered([
      {
        id: questions(:one).id,
        title: questions(:one).title,
        content: questions(:one).content,
        user_id: users(:guojing).id,
        created_at: questions(:one).created_at.as_json,
        updated_at: questions(:one).updated_at.as_json,
        number_of_likes: questions(:one).likes.size,
        liked: false
      },
      {
        id: questions(:two).id,
        title: questions(:two).title,
        content: questions(:two).content,
        user_id: users(:guojing).id,
        created_at: questions(:two).created_at.as_json,
        updated_at: questions(:two).updated_at.as_json,
        number_of_likes: questions(:two).likes.size,
        liked: false
      }
    ], json_response['questions'])
  end

end
