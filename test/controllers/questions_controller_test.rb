require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest

  # ==========================
  # Action show
  # ==========================

  test "should show models" do
    get questions_url

    assert_response :ok
  end

  test "should return 404" do
    Question.destroy_all

    get questions_url

    assert_response :not_found
  end

  # ==========================
  # View INDEX
  # ==========================

  test "should show view INDEX" do
    get questions_url

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
