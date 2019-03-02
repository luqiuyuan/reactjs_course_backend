require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  
  # ==========================
  # Action index
  # ==========================

  test "should show models" do
    get questions_url + "/" + questions(:one).id.to_s + "/answers", headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404" do
    get questions_url + "/" + questions(:two).id.to_s + "/answers", headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should return 404 with non-existing question" do
    get questions_url + "/1234567/answers", headers: login_as(:guojing)

    assert_response :not_found
  end

  # ==========================
  # Action show
  # ==========================

  test "should show model" do
    get base_url + "/answers/" + answers(:one).id.to_s, headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404 for show" do
    get base_url + "/answers" + "/1234567", headers: login_as(:guojing)

    assert_response :not_found
  end

  # ==========================
  # Action create
  # ==========================

  test "should create model" do
    post questions_url + "/" + questions(:one).id.to_s + "/answers", headers: login_as(:guojing), params: { answer: { content: "New Content" } }

    assert_response :created
  end

  test "should return 404 with non-existing question for create" do
    post questions_url + "/1234567/answers", headers: login_as(:guojing), params: { answer: { content: "New Content" } }

    assert_response :not_found
  end

  test "should not create model without answer" do
    post questions_url + "/" + questions(:one).id.to_s + "/answers", headers: login_as(:guojing)

    assert_response :bad_request
    assert hash_included_unordered({
      errors: [
        { code: "missing_field", field: "answer" }
      ]
    }, json_response)
  end

  test "should not create model with invalid answer:content" do
    post questions_url + "/" + questions(:one).id.to_s + "/answers", headers: login_as(:guojing), params: { answer: { content: "a" * (Answer::CONTENT_LENGTH_MAX + 1) } }

    assert_response :bad_request
    assert hash_included_unordered({
      errors: [
        { code: "invalid_field", field: "answer:content" }
      ]
    }, json_response)
  end

  # ==========================
  # Action update
  # ==========================

  test "should update model" do
    patch base_url + "/answers/" + answers(:one).id.to_s, params: { answer: { content: "New Content" } }, headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404 for update" do
    patch base_url + "/answers" + "/1234567", params: { answer: { content: "New Content" } }, headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should return 403" do
    patch base_url + "/answers/" + answers(:one).id.to_s, params: { answer: { content: "New Content" } }, headers: login_as(:huangrong)

    assert_response :forbidden
  end

  # ==========================
  # Action destroy
  # ==========================

  test "should destroy model" do
    delete base_url + "/answers/" + answers(:one).id.to_s, headers: login_as(:guojing)

    assert_response :ok
  end

  test "should return 404 for destroy" do
    delete base_url + "/answers" + "/1234567", headers: login_as(:guojing)

    assert_response :not_found
  end

  test "should return 403 for destroy" do
    delete base_url + "/answers/" + answers(:one).id.to_s, headers: login_as(:huangrong)

    assert_response :forbidden
  end

  # ==========================
  # View SHOW
  # ==========================

  test "should show view SHOW" do
    post questions_url + "/" + questions(:one).id.to_s + "/answers", headers: login_as(:guojing), params: { answer: { content: "New Content" } }

    assert_response :created
    assert hash_included_unordered({
      answer: {
        id: Answer.last.id,
        content: "New Content",
        question_id: questions(:one).id,
        user_id: users(:guojing).id,
        created_at: Answer.last.created_at.as_json,
        updated_at: Answer.last.updated_at.as_json,
        number_of_likes: Answer.last.likes.size
      }
    }, json_response)
  end

  # ==========================
  # View INDEX
  # ==========================

  test "should show view INDEX" do
    get questions_url + "/" + questions(:one).id.to_s + "/answers", headers: login_as(:guojing)

    assert_response :ok
    assert hash_included_unordered({
      answers: [
        {
          id: answers(:one).id,
          content: answers(:one).content,
          question_id: questions(:one).id,
          user_id: users(:guojing).id,
          created_at: answers(:one).created_at.as_json,
          updated_at: answers(:one).updated_at.as_json,
          number_of_likes: answers(:one).likes.size
        },
        {
          id: answers(:two).id,
          content: answers(:two).content,
          question_id: questions(:one).id,
          user_id: users(:guojing).id,
          created_at: answers(:two).created_at.as_json,
          updated_at: answers(:two).updated_at.as_json,
          number_of_likes: answers(:two).likes.size
        }
      ]
    }, json_response)
  end

  private

    def base_url
      return "http://www.example.com"
    end

end
