class AnswersController < ApplicationController

  before_action :authenticate_user_token, only: [:create]
  before_action :set_question, only: [:index, :create]
  before_action :set_user_logged_in, only: [:create]

  # GET questions/:id/answers
  def index
    @answers = @question.answers

    if !@answers.empty?
      render json: { answers: @answers }, status: :ok
    else
      render status: :not_found
    end
  end

  # POST questions/:id/answers
  def create
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = @user_logged_in
    if @answer.save
      render json: { answer: @answer }, status: :created
    else
      @errors = translateModelErrors @answer
      add_prefix_to_field @errors, "answer:"
      render json: { errors: @errors }, status: :bad_request
    end
  rescue ActionController::ParameterMissing
    @errors = [Error.new('missing_field', 'answer')]
    render json: { errors: @errors }, status: :bad_request
  end

  private

    def set_question
      @question = Question.find(params[:question_id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    # Strong parameter of model Answer
    def answer_params
      params.require(:answer).permit(:content)
    end

end
