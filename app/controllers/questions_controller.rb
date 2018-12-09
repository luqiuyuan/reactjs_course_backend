class QuestionsController < ApplicationController

  before_action :authenticate_user_token, only: [:index, :create]
  before_action :set_user_logged_in, only: [:create]

  # GET /questions
  def index
    @questions = Question.all

    if !@questions.empty?
      render json: { questions: @questions }, status: :ok
    else
      render status: :not_found
    end
  end

  # POST /questions
  def create
    @question = Question.new(question_params)
    @question.user = @user_logged_in
    if @question.save
      render json: { question: @question }, status: :created
    else
      @errors = translateModelErrors @question
      add_prefix_to_field @errors, "question:"
      render json: { errors: @errors }, status: :bad_request
    end
  rescue ActionController::ParameterMissing
    @errors = [Error.new('missing_field', 'question')]
    render json: { errors: @errors }, status: :bad_request
  end

  private

    # Strong parameter of model Question
    def question_params
      params.require(:question).permit(:title, :content)
    end

end
