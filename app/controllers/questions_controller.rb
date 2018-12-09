class QuestionsController < ApplicationController

  before_action :authenticate_user_token, only: [:index, :create]

  # GET /questions
  def index
    @questions = Question.all

    if !@questions.empty?
      render json: { questions: @questions }, status: :ok
    else
      render status: :not_found
    end
  end

end
