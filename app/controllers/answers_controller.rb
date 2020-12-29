class AnswersController < ApplicationController

  before_action :authenticate_user_token, only: [:create, :update, :destroy]
  before_action :set_question, only: [:index, :create]
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :set_user_logged_in, only: [:show, :index, :create, :update, :destroy]
  before_action :validate_access, only: [:update, :destroy]

  # GET questions/:id/answers
  def index
    @answers = @question.answers

    if !@answers.empty?
      render json: { answers: view_index(@answers, @user_logged_in) }, status: :ok
    else
      render status: :not_found
    end
  end

  # GET answers/:id
  def show
    render json: { answer: view_show(@answer, @user_logged_in) }, status: :ok
  end

  # POST questions/:id/answers
  def create
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = @user_logged_in
    if @answer.save
      render json: { answer: view_show(@answer, @user_logged_in) }, status: :created
    else
      @errors = translateModelErrors @answer
      add_prefix_to_field @errors, "answer:"
      render json: { errors: @errors }, status: :bad_request
    end
  rescue ActionController::ParameterMissing
    @errors = [Error.new('missing_field', 'answer')]
    render json: { errors: @errors }, status: :bad_request
  end

  # PATCH /answers/:id
  # PUT /answers/:id
  def update
    if @answer.update(answer_params)
      render json: { answer: view_show(@answer, @user_logged_in) }, status: :ok
    else
      @errors = translateModelErrors @question
      add_prefix_to_field @errors, "answer:"
      render json: { errors: @errors }, status: :bad_request
    end
  rescue ActionController::ParameterMissing
    @errors = [Error.new('missing_field', 'answer')]
    render json: { errors: @errors }, status: :bad_request
  end

  # DELETE /answers/:id
  def destroy
    @answer.destroy
    render json: { answer: view_show(@answer, @user_logged_in) }, status: :ok
  end

  private

    def set_question
      @question = Question.find(params[:question_id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    def set_answer
      @answer = Answer.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    # Strong parameter of model Answer
    def answer_params
      params.require(:answer).permit(:content)
    end

    # Check if the logged-in user has access to the answer
    def validate_access
      if @user_logged_in != @answer.user
        render status: :forbidden
      end
    end

    def view_index(answers, user)
      answers_view = []
      answers.each do |answer|
        answers_view.push({
          id: answer.id,
          content: answer.content,
          question_id: answer.question_id,
          user_id: answer.user_id,
          created_at: answer.created_at,
          updated_at: answer.updated_at,
          number_of_likes: answer.likes.size,
          liked: !answer.likes.where(user: user).empty?
        })
      end
      return answers_view
    end

    def view_show(answer, user)
      return {
        id: answer.id,
        content: answer.content,
        question_id: answer.question_id,
        user_id: answer.user_id,
        created_at: answer.created_at,
        updated_at: answer.updated_at,
        number_of_likes: answer.likes.size,
        liked: !answer.likes.where(user: user).empty?
      }
    end

end
