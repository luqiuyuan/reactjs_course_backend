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
  # Action create
  # ==========================

  test "should create model" do
    post questions_url, headers: login_as(:guojing), params: { question: { title: "New Title" } };

    assert_response :created
  end

  test "should not create model without question" do
    post questions_url, headers: login_as(:guojing)

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "missing_field", field: "question" }], json_response['errors'])
  end

  test "should not create model with invalid question:title" do
    post questions_url, headers: login_as(:guojing), params: { question: { title: "a" * (Question::TITLE_LENGTH_MAX + 1) } };

    assert_response :bad_request
    assert hash_included_array_unordered([{ code: "invalid_field", field: "question:title" }], json_response['errors'])
  end

  # ==========================
  # View SHOW
  # ==========================

  test "should show view SHOW" do
    post questions_url, headers: login_as(:guojing), params: { question: { title: "New Title" } };

    assert_response :created
    assert hash_included_unordered({
      question: {
        id: Question.last.id,
        title: "New Title",
        user_id: users(:guojing).id,
        created_at: Question.last.created_at.as_json,
        updated_at: Question.last.updated_at.as_json
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
        user_id: users(:guojing).id,
        created_at: questions(:one).created_at.as_json,
        updated_at: questions(:one).updated_at.as_json
      },
      {
        id: questions(:two).id,
        title: questions(:two).title,
        user_id: users(:guojing).id,
        created_at: questions(:two).created_at.as_json,
        updated_at: questions(:two).updated_at.as_json
      }
    ], json_response['questions'])
  end

end
