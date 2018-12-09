class QuestionsController < ApplicationController

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
